import 'package:flutter/material.dart';
import '/shared/text_styles.dart';

class TextLinkButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final TextStyle? style;

  const TextLinkButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style:
            style ??
            AppTextStyles.bodyMedium.copyWith(
              color: color ?? Colors.blueAccent,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
      ),
    );
  }
}
