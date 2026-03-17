import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';

class BestValueBadge extends StatelessWidget {
  const BestValueBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingS,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.star_rounded, size: 13, color: AppColors.white),
            SizedBox(width: 4),
            AppText(
              'الأفضل قيمة',
              style: TextStyle(
                fontSize: AppDimensions.fontXS,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}