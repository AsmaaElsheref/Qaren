import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_colors_ext.dart';
import '../../../../../core/ui/widgets/AppText.dart';

/// Small chip that displays a counter (selected / unselected apps).
class TaxiCounterChip extends StatelessWidget {
  const TaxiCounterChip({
    super.key,
    required this.label,
    required this.active,
  });

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: active ? AppColors.primary.withValues(alpha: 0.12) : colors.disabledBackground,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: AppText(
        label,
        style: TextStyle(
          fontSize: AppDimensions.fontS,
          fontWeight: FontWeight.w600,
          color: active ? AppColors.primary : colors.textSecondary,
        ),
      ),
    );
  }
}

