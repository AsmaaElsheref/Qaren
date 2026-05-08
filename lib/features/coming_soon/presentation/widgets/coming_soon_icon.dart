import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/constants/app_dimensions.dart';

class ComingSoonIcon extends StatelessWidget {
  const ComingSoonIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.construction_rounded,
              size: AppDimensions.iconL * 1.6,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

