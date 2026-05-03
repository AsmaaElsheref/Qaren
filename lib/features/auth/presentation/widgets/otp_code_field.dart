import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';

class OtpCodeField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const OtpCodeField({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      maxLength: 10,
      validator: validator,
      style: AppTextStyles.title.copyWith(
        letterSpacing: 8,
        color: AppColors.primary,
      ),
      decoration: InputDecoration(
        counterText: '',
        hintText: '• • • • • •',
        hintStyle: AppTextStyles.title.copyWith(
          letterSpacing: 8,
          color: AppColors.textHint,
        ),
      ),
    );
  }
}

