import 'package:flutter/material.dart';
import '/shared/app_colors.dart';
import '/shared/text_styles.dart'; // Import your shared text styles

class PrimaryOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double borderRadius;
  final Color? borderColor;
  final Color? textColor;
  final TextStyle? textStyle;

  const PrimaryOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 48,
    this.borderRadius = 12,
    this.borderColor,
    this.textColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveBorderColor = borderColor ?? AppColors.primary;
    final Color effectiveTextColor = textColor ?? AppColors.primary;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: effectiveTextColor,
          side: BorderSide(color: effectiveBorderColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: textStyle ?? AppTextStyles.labelLarge,
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
