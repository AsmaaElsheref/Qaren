import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.validator,
  });

  @override
  State<PasswordTextField> createState() => PasswordTextFieldState();
}

class PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      validator: widget.validator,
      style: TextStyle(
        fontSize: AppDimensions.fontM,
        color: colors.textPrimary,
        fontFamily: 'Cairo',
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppTextStyles.bodySecondary.copyWith(
          color: AppColors.textHint,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Icon(
            Icons.lock_outline_rounded,
            color: colors.textSecondary,
            size: AppDimensions.iconS,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: AppDimensions.inputHeight,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: colors.textSecondary,
            size: AppDimensions.iconS,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }
}

