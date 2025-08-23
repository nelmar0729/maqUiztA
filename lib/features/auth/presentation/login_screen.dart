import '/shared/widgets/app_footer.dart'; // import this
import '/shared/util/network_utils.dart';
import 'package:flutter/material.dart';
import '/core/routes/app_router.dart';
import 'package:auto_route/auto_route.dart';
import '/shared/helpers.dart';
// Widgets
import '/shared/widgets/app_logo.dart';
import '/shared/app_colors.dart';
import '/shared/widgets/primary_outlined_button.dart';
import '/shared/widgets/primary_button.dart';
import '/shared/widgets/primary_text_field.dart';
import '/shared/widgets/password_text_field.dart';
import '/shared/widgets/text_link_button.dart';
import '/shared/text_styles.dart';

import '/features/auth/domain/usecases/login.dart';
import '/features/auth/data/datasources/auth_remote_data_source.dart';
import '/features/auth/data/repositories/auth_repository_impl.dart';

import '/shared/widgets/overlay_loader.dart';
import '/shared/widgets/snackbar.dart';

// Import your AuthService from domain/services
import '/features/auth/domain/services/auth_service.dart';
import '/core/di.dart'; // For locator
import '/features/auth/data/datasources/local_auth_datasource.dart';

@RoutePage() // <-- Required for auto_route 10.x
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthRemoteDataSource dataSource;
  late final AuthRepositoryImpl repository;
  late final Login loginUseCase;
  late final LocalAuthDataSource localAuth; // <-- Use locator for DI!
  late final AuthService authService;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dataSource = AuthRemoteDataSourceImpl();
    repository = AuthRepositoryImpl(dataSource);
    loginUseCase = Login(repository);

    localAuth = locator<LocalAuthDataSource>(); // <-- Use locator!
    authService = locator<AuthService>();
  }

  Future<void> _navigateBasedOnAuth() async {
    final result = await authService.checkAuthStatus();
    switch (result.status) {
      case AuthStatus.enrolled:
        context.router.replace(const QuizterNavRoute());
        break;
      case AuthStatus.notProfiled:
        context.router.replace(const ProfileSetupRoute());
        break;
      case AuthStatus.notLoggedIn:
        context.router.replace(const LoginRoute());
        break;
    }
  }

  Future<void> handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (!context.mounted) return;
      OverlayLoader.show(context, message: "Logging in...");

      // ✅ Wrap loginUseCase with safeApiCall
      final result = await safeApiCall(
        context,
        () => loginUseCase(
          _emailController.text.trim(),
          _passwordController.text,
        ),
      );

      if (!context.mounted) return;

      if (result != null &&
          result.success &&
          result.data != null &&
          result.data is String &&
          result.data.isNotEmpty) {
        // ✅ Login success
        await localAuth.saveToken(result.data);
        AppSnack.show(context, result.message, SnackType.success);
        await _navigateBasedOnAuth();
      } else if (result != null) {
        // 🔎 check statusCode
        if (result.statusCode == 403) {
          AppSnack.show(
            context,
            "Please verify your email before logging in.",
            SnackType.error,
          );

          // 🔀 redirect to verification page
          context.router.replace(
            EmailVerificationRoute(email: _emailController.text.trim()),
          );
        } else {
          // normal error (wrong password, not registered, etc.)
          AppSnack.show(context, result.message, SnackType.error);
        }
      }
      // ⚡ If result == null, safeApiCall already showed "No Internet 🚫"
    } catch (e) {
      if (!context.mounted) return;
      AppSnack.show(context, "Something went wrong: $e", SnackType.error);
    } finally {
      OverlayLoader.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 👈 pushes footer down
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Gradient blue header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 70, bottom: 28),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: AppLogo(
                        size: 400,
                        showText: false,
                        type: AppLogoType.landscape,
                      ),
                    ),
                  ),
                  // The rest of the form
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          "Login",
                          style: AppTextStyles.displayLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              PrimaryTextField(
                                controller: _emailController,
                                label: 'Email',
                                prefixIcon: Icons.email_outlined,
                                validator:
                                    AppHelpers.required("Email is required!"),
                              ),
                              const SizedBox(height: 20),
                              PasswordTextField(
                                controller: _passwordController,
                                validator: AppHelpers.required(
                                  'Please enter your password',
                                ),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextLinkButton(
                                  text: "Forgot password?",
                                  onPressed: () {
                                    context.router
                                        .push(const ForgotPasswordRoute());
                                  },
                                ),
                              ),
                              const SizedBox(height: 24),
                              PrimaryButton(
                                text: "Login",
                                onPressed: () {
                                  handleLogin();
                                },
                              ),
                              const SizedBox(height: 16),
                              PrimaryOutlinedButton(
                                text: "Create Account",
                                onPressed: () {
                                  context.router.push(const RegisterRoute());
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const AppFooter(), // 👈 footer stays fixed at the bottom
        ],
      ),
    );
  }
}
