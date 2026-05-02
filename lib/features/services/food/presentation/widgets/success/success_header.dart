import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../food_strings.dart';

/// Success-screen header — title + animated check icon.
class SuccessHeader extends StatelessWidget {
  const SuccessHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.paddingL,
      ),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.primary,
              size: 60,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          const AppText(
            FoodStrings.successTitle,
            style: TextStyle(
              fontSize: AppDimensions.fontXL,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const AppText(
            FoodStrings.successSubtitle,
            secondary: true,
            style: TextStyle(fontSize: AppDimensions.fontS),
          ),
        ],
      ),
    );
  }
}

