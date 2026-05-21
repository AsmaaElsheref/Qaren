import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/AppText.dart';

/// Small pill badge shown on disabled category cards to signal upcoming availability.
class CategoryAvailabilityBadge extends StatelessWidget {
  const CategoryAvailabilityBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        'قريبًا',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          height: 1.4,
        ),
      ),
    );
  }
}

