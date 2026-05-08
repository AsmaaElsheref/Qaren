import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

class BookingStatusBadge extends StatelessWidget {
  final String status;
  final String label;

  const BookingStatusBadge({
    super.key,
    required this.status,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final color = switch (normalized) {
      'confirmed' || 'completed' || 'success' => AppColors.success,
      'cancelled' || 'canceled' || 'failed' => AppColors.error,
      'pending' => AppColors.primary,
      _ => AppColors.textSecondary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: AppText(
        label.isEmpty ? 'قيد الانتظار' : label,
        style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

