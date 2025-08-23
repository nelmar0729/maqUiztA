// ignore_for_file: deprecated_member_use
import '/shared/util/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '/shared/app_colors.dart';
import '/shared/widgets/primary_button.dart';
import '/shared/widgets/text_link_button.dart';
import '/features/auth/domain/usecases/send_password_reset_link.dart';
import '/features/auth/data/datasources/auth_remote_data_source.dart';
import '/features/auth/data/repositories/auth_repository_impl.dart';
import '/shared/widgets/snackbar.dart';
import '/core/routes/app_router.dart';

@RoutePage() // <-- Required for auto_route 10.x
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final AuthRemoteDataSource dataSource;
  late final AuthRepositoryImpl repository;
  late final SendPasswordResetLink sendPasswordResetLink;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    dataSource = AuthRemoteDataSourceImpl();
    repository = AuthRepositoryImpl(dataSource);
    sendPasswordResetLink = SendPasswordResetLink(repository);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final result = await safeApiCall(
      context,
      () => sendPasswordResetLink(_emailController.text.trim()),
    );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (result != null && result.success) {
      AppSnack.show(context, result.message, SnackType.success);

    } else if (result != null) {
      setState(() {
        _errorMessage = result.message;
      });
    }
    // ⚡ If result == null, safeApiCall already showed "No Internet 🚫"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock_reset, color: Color(0xFF00C6FB), size: 60),
              const SizedBox(height: 20),
              const Text(
                "Forgot your password?",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter your registered email address. We'll send you a link to reset your password.",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black54,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontFamily: 'Poppins'),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined),
                    labelText: 'Email Address',
                    labelStyle: const TextStyle(fontFamily: 'Poppins'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!RegExp(
                      r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),

              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 30),

              PrimaryButton(
                text: _isSubmitting ? "Sending..." : "Send Reset Link",
                onPressed: () {
                  if (_isSubmitting) {
                    return; // 🔒 Prevents clicks while submitting
                  }
                  _submit();
                },
              ),

              const SizedBox(height: 15),

              TextLinkButton(
                text: "Already have an account? Login",
                onPressed: () {
                  context.router.replace(const LoginRoute());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
