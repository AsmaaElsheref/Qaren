import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';

class EstimatedTime extends StatelessWidget {
  const EstimatedTime({super.key, required this.minutes});

  final int minutes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const AppText(
          'السعر التقديري',
          secondary: true,
          style: TextStyle(fontSize: AppDimensions.fontXS),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 13,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            AppText(
              '$minutes دقيقة',
              secondary: true,
              style: TextStyle(fontSize: AppDimensions.fontXS,color: AppColors.black),
            ),
          ],
        ),
      ],
    );
  }
}