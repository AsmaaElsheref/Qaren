import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';

/// Shimmer skeleton that mimics the layout of [FoodItemCard].
///
/// Rendered inside [FoodItemList] while [foodItemsProvider] is loading.
/// Shows 4 placeholder rows so the skeleton fills the card area naturally.
class FoodItemShimmer extends StatelessWidget {
  const FoodItemShimmer({super.key});

  static const int _itemCount = 4;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surface,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _itemCount,
        padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          indent: AppDimensions.paddingM,
          endIndent: AppDimensions.paddingM,
          color: AppColors.border,
        ),
        itemBuilder: (_, __) => const FoodItemShimmerRow(),
      ),
    );
  }
}

/// Single shimmer row — matches the visual structure of one [FoodItemCard].
class FoodItemShimmerRow extends StatelessWidget {
  const FoodItemShimmerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingM,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          // Text lines placeholder
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                _ShimmerBox(width: double.infinity, height: 14),
                const SizedBox(height: 8),
                _ShimmerBox(width: 200, height: 11),
                const SizedBox(height: 6),
                _ShimmerBox(width: 120, height: 11),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ShimmerBox(width: 60, height: 16),
                    _ShimmerBox(
                      width: 32,
                      height: 32,
                      borderRadius: AppDimensions.radiusM,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable coloured box used to build shimmer placeholder shapes.
class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius = AppDimensions.radiusS,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

