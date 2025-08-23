import 'package:flutter/material.dart';
import '/shared/app_colors.dart';
import '/shared/text_styles.dart'; // Import your text styles

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double borderRadius;
  final Color? backgroundColor; // nullable for theme fallback
  final Color? textColor; // nullable for theme fallback
  final TextStyle? textStyle; // nullable for custom style

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 48,
    this.borderRadius = 12,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    // Use provided color or fallback to your app color
    final Color effectiveBackgroundColor = backgroundColor ?? AppColors.primary;
    final Color effectiveTextColor = textColor ?? AppColors.textOnPrimary;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: textStyle ?? AppTextStyles.labelLarge, // Use shared style
        ),
        child: Text(
          text,
          style: (textStyle ?? AppTextStyles.labelLarge).copyWith(
            color: effectiveTextColor,
          ),
        ),
      ),
    );
  }
}
