import '/shared/util/network_utils.dart';
import 'package:flutter/material.dart';
//Widgets
import '/shared/widgets/app_logo.dart';
import '/shared/widgets/primary_button.dart';
import '/shared/widgets/otp_input.dart'; // <-- Add this!
import '/shared/text_styles.dart';
import '/shared/widgets/overlay_loader.dart'; // If you use the loader
import '/shared/widgets/snackbar.dart'; //
import '/shared/widgets/text_link_button.dart';

import '/features/auth/domain/usecases/resend_code.dart';
import '/features/auth/data/datasources/auth_remote_data_source.dart';
import '/features/auth/data/repositories/auth_repository_impl.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';

import '/features/profile/data/datasources/data_source.dart';
import '/features/profile/data/repositories/repository_impl.dart';
import '/features/profile/domain/usecases/verify_email.dart';
import '/shared/response.dart';

import 'package:auto_route/auto_route.dart';

@RoutePage() // <-- Required for auto_route 10.x
class NewEmailVerificationScreen extends StatefulWidget {
  final String email;

  const NewEmailVerificationScreen({super.key, this.email = 'your@email.com'});

  @override
  State<NewEmailVerificationScreen> createState() =>
      _NewEmailVerificationScreenState();
}

class _NewEmailVerificationScreenState
    extends State<NewEmailVerificationScreen> {
  /* Auth Data source */
  late final AuthRemoteDataSource authDataSource;
  late final AuthRepositoryImpl authDatarepository;
  late final ResendCode resendCodeUseCase;
  final localAuth = LocalAuthDataSource();
  /*end Auth Data source */

  late final DataSource dataSource;
  late final RepositoryImpl repositoryImpl;
  late final VerifyEmail verifyEmail;

  String _otp = "";
  String? _error;

  @override
  void initState() {
    super.initState();
    authDataSource = AuthRemoteDataSourceImpl();
    authDatarepository = AuthRepositoryImpl(authDataSource);
    resendCodeUseCase = ResendCode(authDatarepository);

    dataSource = DataSourceImpl();
    repositoryImpl = RepositoryImpl(dataSource);
    verifyEmail = VerifyEmail(repositoryImpl);
  }

  Future<void> handleVerifyEmail(String code) async {
    if (!context.mounted) return;

    setState(() => _error = null);

    // Validate code format first
    if (code.length != 4 || !RegExp(r'^\d{4}$').hasMatch(code)) {
      setState(() {
        _error = "Please enter the 4-digit code.";
      });
      return;
    }

    OverlayLoader.show(context, message: "Verifying...");

    final result = await safeApiCall<ResponseResult>(
      context,
      () => verifyEmail(email: widget.email, token: code),
    );

    OverlayLoader.hide();
    if (!context.mounted) return;

    if (result == null) return; // Already handled by safeApiCall

    if (result.success) {
      // Save JWT token if returned
      if (result.data != null &&
          result.data is String &&
          result.data.isNotEmpty) {
        await localAuth.saveToken(result.data);
      }

      AppSnack.show(context, result.message, SnackType.success);
      context.router.pop(); // ✅ Auto-close on success
    } else {
      AppSnack.show(context, result.message, SnackType.error);
    }
  }

  Future<void> handleResendCode() async {
    if (!context.mounted) return;

    setState(() => _error = null);
    OverlayLoader.show(context, message: "Resending...");
    final result = await safeApiCall<ResponseResult>(
      context,
      () => resendCodeUseCase(widget.email),
    );

    OverlayLoader.hide();
    if (!context.mounted) return;

    if (result == null) return; // Already handled by safeApiCall

    if (result.success) {
      AppSnack.show(context, result.message, SnackType.success);
    } else {
      AppSnack.show(context, result.message, SnackType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 44),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AppLogo(),
              const SizedBox(height: 18),
              Text(
                "Enter the 4-digit code sent to your email address to verify your new email.",
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
