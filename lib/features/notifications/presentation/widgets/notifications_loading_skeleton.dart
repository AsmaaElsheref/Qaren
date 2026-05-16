import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class NotificationsLoadingSkeleton extends StatelessWidget {
  const NotificationsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.surfaceVariant,
          highlightColor: AppColors.white,
          child: Container(
            height: index == 0 ? 78 : 116,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.paddingM),
      itemCount: 6,
    );
  }
}

