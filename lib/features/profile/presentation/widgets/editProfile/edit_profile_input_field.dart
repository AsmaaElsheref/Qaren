import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';

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
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          label,
          style: TextStyle(
            fontSize: AppDimensions.fontS,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
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
          style: TextStyle(
            fontSize: AppDimensions.fontM,
            color: colors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(
              icon,
              color: colors.textSecondary,
              size: AppDimensions.iconS,
            ),
          ),
        ),
      ],
    );
  }
}

