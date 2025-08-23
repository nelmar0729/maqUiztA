// lib/shared/text_styles.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';

/// AppTextStyles
///
/// A central place to define reusable text styles for your app.
/// Use these for headlines, body text, buttons, captions, etc.
/// Keeps your typography consistent across the app.
///
/// Usage Example:
///   Text('Hello', style: AppTextStyles.headlineLarge)
class AppTextStyles {
  // Large display headline (e.g. onboarding titles, main headlines)
  static const TextStyle displayLarge = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  // Large section titles (e.g. app bar, section headers)
  static const TextStyle titleLarge = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle titleMedium = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle titleSmall = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  // Main body text
  static const TextStyle bodyLarge = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
  );

  // Secondary body text (for less important details)
  static const TextStyle bodyMedium = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
  );

  // Caption/small text (e.g. for helper text or captions)
  static const TextStyle bodySmall = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
  );

  // Large label/button text
  static const TextStyle labelLarge = TextStyle(
    color: AppColors.textOnPrimary,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.5,
  );

  // Optional: Medium and small label styles
  static const TextStyle labelMedium = TextStyle(
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );
  static const TextStyle labelSmall = TextStyle(
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );

  static const TextStyle labelError = TextStyle(
    color: AppColors.warning,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  // You can add more custom styles as needed!
}
