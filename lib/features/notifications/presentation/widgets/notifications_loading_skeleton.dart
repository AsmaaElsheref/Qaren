import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:shimmer/shimmer.dart';

class NotificationsLoadingSkeleton extends StatelessWidget {
  const NotificationsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: colors.disabledBackground,
          highlightColor: colors.surface,
          child: Container(
            height: index == 0 ? 78 : 116,
            decoration: BoxDecoration(
              color: colors.disabledBackground,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.paddingM),
      itemCount: 6,
    );
  }
}
