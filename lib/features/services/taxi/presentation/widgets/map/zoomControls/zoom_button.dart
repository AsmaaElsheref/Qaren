import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../../core/theme/app_colors.dart';

class ZoomButton extends StatelessWidget {
  const ZoomButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: AppDimensions.iconS),
      ),
    );
  }
}
