import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class LoginInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? customSuffix;

  const LoginInputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.customSuffix, this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      validator: validator,
      style: TextStyle(
        fontSize: AppDimensions.fontM,
        color: colors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.textHint,
          fontSize: AppDimensions.fontM,
        ),
        prefixIcon: customSuffix ??
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                prefixIcon,
                color: colors.textSecondary,
                size: AppDimensions.iconS,
              ),
            ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: AppDimensions.inputHeight,
        ),
        suffixIcon: suffixIcon
      ),
    );
  }
}

