import 'package:flutter/material.dart';
import '/shared/app_colors.dart';
import '/shared/text_styles.dart';

enum IconPosition { start, end }

class PrimaryButtonWithIcon extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final IconPosition iconPosition;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final TextStyle? textStyle;

  const PrimaryButtonWithIcon({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconPosition = IconPosition.start,
    this.height = 48,
    this.borderRadius = 12,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveBackgroundColor = backgroundColor ?? AppColors.primary;
    final Color effectiveTextColor = textColor ?? AppColors.textOnPrimary;
    final Color effectiveIconColor = iconColor ?? effectiveTextColor;

    List<Widget> children = [
      if (icon != null && iconPosition == IconPosition.start)
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(icon, color: effectiveIconColor, size: 22),
        ),
      Text(
        text,
        style: (textStyle ?? AppTextStyles.labelLarge).copyWith(
          color: effectiveTextColor,
        ),
      ),
      if (icon != null && iconPosition == IconPosition.end)
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Icon(icon, color: effectiveIconColor, size: 22),
        ),
    ];

    return SizedBox(
      height: height,
      // No width property = sizes to content
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          textStyle: textStyle ?? AppTextStyles.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ), // Custom padding for nice fit
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // <-- important: shrink to content
          children: children,
        ),
      ),
    );
  }
}
