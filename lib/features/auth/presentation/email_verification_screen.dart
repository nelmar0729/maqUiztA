import 'package:flutter/material.dart';
import '/core/routes/app_router.dart';
//Widgets
import '/shared/widgets/app_logo.dart';
import '/shared/widgets/primary_button.dart';
import '/shared/widgets/otp_input.dart'; // <-- Add this!
import '/shared/text_styles.dart';
import '/shared/widgets/overlay_loader.dart'; // If you use the loader
import '/shared/widgets/snackbar.dart'; //
import '/shared/widgets/text_link_button.dart';

import '/features/auth/domain/usecases/verify_email.dart';
import '/features/auth/domain/usecases/resend_code.dart';
import '/features/auth/data/datasources/auth_remote_data_source.dart';
import '/features/auth/data/repositories/auth_repository_impl.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';

// Import your AuthService from domain/services
import '/features/auth/domain/services/auth_service.dart';
import '/core/di.dart'; // For locator

import 'package:auto_route/auto_route.dart';

@RoutePage() // <-- Required for auto_route 10.x
class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({super.key, this.email = 'your@email.com'});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  late final AuthRemoteDataSource dataSource;
  late final AuthRepositoryImpl repository;
  late final VerifyEmail verifyEmailUseCase;
  late final ResendCode resendCodeUseCase;
  late final LocalAuthDataSource localAuth; // <-- Use locator for DI!

  late final AuthService authService;

  String _otp = "";
  String? _error;

  @override
  void initState() {
    super.initState();
    localAuth = locator<LocalAuthDataSource>(); // <-- Use locator!
    authService = locator<AuthService>();

    dataSource = AuthRemoteDataSourceImpl();
    repository = AuthRepositoryImpl(dataSource);
    verifyEmailUseCase = VerifyEmail(repository);
    resendCodeUseCase = ResendCode(repository);
  }

  Future<void> _navigateBasedOnAuth() async {
    final result = await authService.checkAuthStatus();
    switch (result.status) {
      case AuthStatus.enrolled:
        context.router.replaceAll([const QuizterNavRoute()]);
        break;
      case AuthStatus.notProfiled:
        context.router.replaceAll([const ProfileSetupRoute()]);
        break;
      case AuthStatus.notLoggedIn:
        context.router.replaceAll([const LoginRoute()]);
        break;
    }
  }

  Future<void> handleVerifyEmail(String code) async {
    try {
      if (!context.mounted) return;
      setState(() {
        _error = null;
      });
      if (code.length != 4 || !RegExp(r'^\d{4}$').hasMatch(code)) {
        setState(() {
          _error = "Please enter the 4-digit code.";
        });
        return;
      }
      OverlayLoader.show(context, message: "Verifying...");

      final result = await verifyEmailUseCase(widget.email, code);

      if (!context.mounted) return;
      if (result.success) {
        // Save JWT token from response!

        if (result.data != null &&
            result.data is String &&
            result.data.isNotEmpty) {
          await localAuth.saveToken(result.data);
          // ✅ Login success
          await localAuth.saveToken(result.data);
          // AppSnack.show(context, result.message, SnackType.success);
          await _navigateBasedOnAuth();
        }

        AppSnack.show(context, result.message, SnackType.success);

        // Now you can auto-login, route, etc.
        // context.router.push(LoginRoute());
      } else {
        AppSnack.show(context, result.message, SnackType.error);
      }
    } catch (e) {
      if (!context.mounted) return;

      AppSnack.show(context, e.toString(), SnackType.error);
    } finally {
      OverlayLoader.hide();
    }
  }

  Future<void> handleResendCode() async {
    try {
      if (!context.mounted) return;
      setState(() {
        _error = null;
      });

      OverlayLoader.show(context, message: "Resending...");

      final result = await resendCodeUseCase(widget.email);

      if (!context.mounted) return;
      if (result.success) {
        AppSnack.show(context, result.message, SnackType.success);
      } else {
        AppSnack.show(context, result.message, SnackType.error);
      }
    } catch (e) {
      if (!context.mounted) return;
      AppSnack.show(context, e.toString(), SnackType.error);
    } finally {
      OverlayLoader.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 👈 change here
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 44),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppLogo(),
              const SizedBox(height: 18),
              Text(
                "Enter the 4-digit code sent to your email address to verify your account.",
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(widget.email, style: AppTextStyles.bodyLarge),
              const SizedBox(height: 32),

              // --- OtpInput Reusable Widget Here! ---
              Center(
                child: SizedBox(
                  width: 250, // adjust this based on box size and spacing!
                  child: OtpInput(
                    length: 4,
                    errorText: _error,
                    onChanged: (val) => setState(() => _otp = val),
                    onCompleted: (val) => handleVerifyEmail(val),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              PrimaryButton(
                text: "Verify",
                onPressed: () {
                  handleVerifyEmail(_otp);
                },
              ),
              const SizedBox(height: 20),
              TextLinkButton(
                text: "Didn't receive a code? Resend",
                onPressed: () {
                  handleResendCode();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
