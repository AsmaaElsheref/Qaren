import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/ui/widgets/AppText.dart';

class SelectionLoading extends StatelessWidget {
  const SelectionLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppText(
          'جاري التحديد...',
          secondary: true,
          style: const TextStyle(
            fontSize: AppDimensions.fontM,
          ),
        ),
        const SizedBox(width: 8),
        const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
