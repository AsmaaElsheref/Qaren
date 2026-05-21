import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:shimmer/shimmer.dart';

class BookingLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const BookingLoadingSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: colors.disabledBackground,
          highlightColor: colors.surface,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: colors.disabledBackground,
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

