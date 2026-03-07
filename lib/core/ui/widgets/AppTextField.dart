import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'AppTextStyles.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int maxLines;
  final int? minLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? fillColor;
  final bool? nonBorder;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon, this.fillColor, this.nonBorder,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: nonBorder==true?BorderSide.none:const BorderSide(color: AppColors.border, width: 1),
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      maxLines: obscureText ? 1 : maxLines,
      minLines: obscureText ? 1 : minLines,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: fillColor??AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelStyle: AppTextStyles.bodySecondary,
        hintStyle: AppTextStyles.bodySecondary,
        enabledBorder: border,
        focusedBorder: border?.copyWith(
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1.2),
        ),
        errorBorder: border?.copyWith(
          borderSide:
              const BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: border?.copyWith(
          borderSide:
              const BorderSide(color: AppColors.error, width: 1.2),
        ),
      ),
    );
  }
}
