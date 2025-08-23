import '/shared/util/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '/shared/helpers.dart';
//Widgets
import '/shared/app_colors.dart';
import '/shared/widgets/primary_button.dart';
import '/shared/widgets/password_text_field.dart';
import '/features/profile/data/datasources/data_source.dart';
import '/features/profile/data/repositories/repository_impl.dart';
import '/features/auth/data/datasources/local_auth_datasource.dart';

import '/features/profile/domain/usecases/change_password.dart';
import '/shared/widgets/overlay_loader.dart';
import '/shared/widgets/snackbar.dart';
import '/shared/response.dart';

@RoutePage()
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late final LocalAuthDataSource localAuthDataSource;
  late final DataSource dataSource;
  late final RepositoryImpl repositoryImpl;
  late final ChangePassword changePassword;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dataSource = DataSourceImpl();
    repositoryImpl = RepositoryImpl(dataSource);
    localAuthDataSource = LocalAuthDataSource();
    changePassword = ChangePassword(repositoryImpl, localAuthDataSource);
  }

  Future<void> handleSavePassword() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) return;

    if (!context.mounted) return;
    OverlayLoader.show(context, message: "Saving password...");

    final result = await safeApiCall<ResponseResult>(
      context,
      () => changePassword(
        currentPassword: _currentController.text.trim(),
        newPassword: _newController.text.trim(),
        confirmPassword: _confirmController.text.trim(),
      ),
    );

    if (!context.mounted) return;

    if (result != null && result.success) {
      AppSnack.show(context, result.message, SnackType.success);
      Navigator.pop(context);
    } else if (result != null) {
      AppSnack.show(context, result.message, SnackType.error);
    }

    OverlayLoader.hide();
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              PasswordTextField(
                controller: _currentController,
                label: "Current Password",
                validator: AppHelpers.required("Enter your current password"),
              ),
              const SizedBox(height: 22),
              PasswordTextField(
                controller: _newController,
                label: "New Password",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 22),
              PasswordTextField(
                controller: _confirmController,
                label: "Confirm New Password",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm your new password';
                  }
                  if (value != _newController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 36),
              PrimaryButton(
                text: "Save Password",
                onPressed: handleSavePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
