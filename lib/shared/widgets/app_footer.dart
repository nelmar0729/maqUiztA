import 'package:flutter/material.dart';
import '/shared/constants.dart';
import '/shared/app_colors.dart';

/// AppFooter
///
/// A reusable footer widget that displays
/// - App version
/// - Developer name
///
/// Uses values from [AppConstants].
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Version ${AppConstants.appVersion}",
            style: const TextStyle(
              color: AppColors.textOnSecondary,
              fontSize: 9,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Developed by: ${AppConstants.developer}",
            style: const TextStyle(
              color: AppColors.textOnSecondary,
              fontSize: 9,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
