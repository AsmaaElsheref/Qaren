import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class BookingLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const BookingLoadingSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.surfaceVariant,
          highlightColor: AppColors.white,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.paddingM),
      itemCount: itemCount,
    );
  }
}

