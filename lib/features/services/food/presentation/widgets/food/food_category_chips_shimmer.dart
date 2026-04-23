import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';

/// Shimmer skeleton that mimics the layout of the [FoodCategoryChips] row.
///
/// Rendered inside [FoodCategoryChips] while [foodCategoriesProvider] is loading.
class FoodCategoryChipsShimmer extends StatelessWidget {
  const FoodCategoryChipsShimmer({super.key});

  static const int _chipCount = 5;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surface,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
        ),
        itemCount: _chipCount,
        separatorBuilder: (_, __) =>
            const SizedBox(width: AppDimensions.paddingS),
        itemBuilder: (_, index) => FoodCategoryChipShimmer(
          width: index == 0 ? 52 : 72.0 + (index % 2) * 16,
        ),
      ),
    );
  }
}

/// A single rounded pill placeholder that matches a [FoodCategoryChip].
class FoodCategoryChipShimmer extends StatelessWidget {
  const FoodCategoryChipShimmer({super.key, this.width = 72});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
    );
  }
}

