import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_colors_ext.dart';
import '../../../../../core/ui/widgets/AppText.dart';

/// Pill-shaped action chip used in the taxi apps drawer (Select All / Clear).
class TaxiActionChip extends StatelessWidget {
  const TaxiActionChip({
    super.key,
    required this.label,
    required this.onTap,
    required this.isPrimary,
  });

  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.primary.withValues(alpha: 0.12)
              : colors.disabledBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        child: AppText(
          label,
          style: TextStyle(
            fontSize: AppDimensions.fontS,
            fontWeight: FontWeight.w600,
            color: isPrimary ? AppColors.primary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

