import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import 'food_item_list.dart';

/// Card container that wraps the food items list.
///
/// Intentionally kept thin — search, chips, and section title live
/// in [FoodPage] so each section has its own independent rebuild scope.
class FoodRestaurantCard extends StatelessWidget {
  const FoodRestaurantCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const FoodItemList(),
    );
  }
}