import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:shimmer/shimmer.dart';

class WalletLoadingSkeleton extends StatelessWidget {
  const WalletLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      itemBuilder: (context, index) {
        final height = index == 0 ? 190.0 : 94.0;
        return Shimmer.fromColors(
          baseColor: colors.disabledBackground,
          highlightColor: colors.surface,
          child: Container(
            height: height,
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
