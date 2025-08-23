import 'package:flutter/material.dart';
import '/shared/app_colors.dart';
import '/shared/text_styles.dart';

class PrimaryDropdown<T> extends StatelessWidget {
  final T? value;
  final String label;
  final IconData? prefixIcon;
  final List<DropdownMenuItem<T>> items;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
  final TextStyle? style;
  final TextStyle? labelStyle;

  const PrimaryDropdown({
    super.key,
    required this.value,
    required this.label,
    this.prefixIcon,
    required this.items,
    this.validator,
    this.onChanged,
    this.style,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      validator: validator,
      onChanged: onChanged,
      style: style ?? AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        labelText: label,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.primary)
            : null,
        labelStyle: labelStyle ?? AppTextStyles.bodyMedium,
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
        // Remove underline from dropdown:
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      ),
      dropdownColor: Colors.white,
      icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
    );
  }
}
