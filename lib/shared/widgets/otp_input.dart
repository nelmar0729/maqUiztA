import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '/shared/text_styles.dart';
import '/shared/app_colors.dart';

class OtpInput extends StatelessWidget {
  final int length;
  final String? errorText;
  final void Function(String) onCompleted;
  final void Function(String)? onChanged;

  const OtpInput({
    super.key,
    this.length = 4,
    required this.onCompleted,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PinCodeTextField(
          appContext: context,
          length: length,
          animationType: AnimationType.scale,
          keyboardType: TextInputType.number,
          autoFocus: true,
          enableActiveFill: true, // ✅ now fills background
          cursorColor: AppColors.primary, // 🔴 Red cursor
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(12),
            fieldHeight: 56,
            fieldWidth: 56,
            borderWidth: 2,

            // 🔴 Active (filled) pin box
            activeColor: AppColors.primary,
            activeFillColor: AppColors.primary.withOpacity(0.1),

            // 🟡 Currently selected pin box
            selectedColor: AppColors.secondary,
            selectedFillColor: AppColors.secondary.withOpacity(0.1),

            // 🔵 Inactive pin box
            inactiveColor: AppColors.accent,
            inactiveFillColor: AppColors.background,
          ),
          onChanged: onChanged ?? (_) {},
          onCompleted: onCompleted,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText!,
              style: AppTextStyles.labelError.copyWith(color: AppColors.error),
            ),
          ),
      ],
    );
  }
}
