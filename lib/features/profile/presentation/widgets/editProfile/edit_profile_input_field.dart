import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';

class EditProfileInputField extends StatelessWidget {
  final String label;
  final String initialValue;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? hintText;

  const EditProfileInputField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.icon,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          label,
          style: const TextStyle(
            fontSize: AppDimensions.fontS,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: AppDimensions.fontM,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(
              icon,
              color: AppColors.textSecondary,
              size: AppDimensions.iconS,
            ),
          ),
        ),
      ],
    );
  }
}

