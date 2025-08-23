import 'package:flutter/material.dart';
import '/shared/app_colors.dart';
import '/shared/text_styles.dart'; // Optional, for shared text styles

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final String? Function(String?)? validator;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final int? maxLength;

  const PasswordTextField({
    super.key,
    this.controller,
    this.label = 'Password',
    this.validator,
    this.style,
    this.labelStyle,
    this.maxLength,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      validator: widget.validator,
      maxLength: widget.maxLength,
      style: widget.style ?? AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
        labelStyle: widget.labelStyle ?? AppTextStyles.bodyMedium,
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.primary,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
          tooltip: _obscure ? 'Show password' : 'Hide password',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }
}
