import '/shared/widgets/app_footer.dart'; // import this
import '/shared/util/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '/core/routes/app_router.dart';
import '/shared/helpers.dart';
//Widgets
import '/shared/widgets/app_logo.dart';
import '/shared/app_colors.dart';
import '/shared/widgets/text_link_button.dart';
import '/shared/widgets/primary_button.dart';
import '/shared/widgets/primary_text_field.dart';
import '/shared/widgets/password_text_field.dart';

import '/features/auth/domain/usecases/register.dart';
import '/features/auth/data/datasources/auth_remote_data_source.dart';
import '/features/auth/data/repositories/auth_repository_impl.dart';

import '/shared/widgets/overlay_loader.dart';
import '/shared/widgets/snackbar.dart';

@RoutePage() // <-- Required for auto_route 10.x
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final AuthRemoteDataSource dataSource;
  late final AuthRepositoryImpl repository;
  late final Register register;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dataSource = AuthRemoteDataSourceImpl();
    repository = AuthRepositoryImpl(dataSource);
    register = Register(repository);
  }

  Future<void> handleRegister() async {
    try {
      if (!context.mounted) return;
      OverlayLoader.show(context, message: "Registering...");

      // ✅ Wrap register() with safeApiCall
      final result = await safeApiCall(
        context,
        () => register(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _studentIdController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        ),
      );

      if (!context.mounted) return;

      if (result != null && result.success) {
        AppSnack.show(context, result.message, SnackType.success);
        context.router.replace(
          EmailVerificationRoute(email: _emailController.text.trim()),
        );
      } else if (result != null) {
        AppSnack.show(context, result.message, SnackType.error);
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
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 👈 pushes footer down
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // LOGO at the very top
                      AppLogo(
                        size: 400,
                        showText: false, // Don't show "Quizter" text under the logo
                        type: AppLogoType.landscape, // Use the landscape logo
                      ),
                      const SizedBox(height: 10),

                      // First Name
                      PrimaryTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        prefixIcon: Icons.person_outline,
                        validator: AppHelpers.required(
                          "Please enter your first name",
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Last Name
                      PrimaryTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        prefixIcon: Icons.person_outline,
                        validator:
                            AppHelpers.required("Please enter your last name"),
                      ),

                      const SizedBox(height: 16),

                      // Student ID
                      PrimaryTextField(
                        controller: _studentIdController,
                        label: 'Student ID',
                        prefixIcon: Icons.badge_outlined,
                        validator: AppHelpers.multi([
                          AppHelpers.required('Please enter your student ID'),
                          AppHelpers.studentId(
                            'Invalid student ID (eg. XXXX-XXXX-A)',
                          ),
                        ]),
                      ),

                      const SizedBox(height: 16),

                      // Email
                      PrimaryTextField(
                        controller: _emailController,
                        label: 'Email',
                        prefixIcon: Icons.email_outlined,
                        validator: AppHelpers.multi([
                          AppHelpers.required('Please enter your email address'),
                          AppHelpers.email("Please enter a valid email address"),
                        ]),
                      ),
                      const SizedBox(height: 16),

                      // Password
                      PasswordTextField(
                        controller: _passwordController,
                        validator:
                            AppHelpers.required('Please enter your password'),
                      ),
                      const SizedBox(height: 28),

                      PrimaryButton(
                        text: "Register",
                        onPressed: () {
                          // This will trigger all validators of the Form's fields
                          if (_formKey.currentState!.validate()) {
                            handleRegister(); // Only called if all fields are valid
                          }
                        },
                      ),

                      const SizedBox(height: 16),
                      TextLinkButton(
                        text: "Already have an account? Login",
                        onPressed: () =>
                            context.router.push(const LoginRoute()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const AppFooter(), // 👈 footer widget
        ],
      ),
    );
  }
}
