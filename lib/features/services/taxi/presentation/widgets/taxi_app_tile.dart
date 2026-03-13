import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/features/services/taxi/presentation/providers/taxi_apps/taxi_app_model.dart';

/// A single selectable row for one taxi app.
/// Purely presentational — receives data and callbacks only.
class TaxiAppTile extends StatelessWidget {
  final TaxiApp app;
  final bool isSelected;
  final VoidCallback onTap;

  const TaxiAppTile({
    super.key,
    required this.app,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingS,
          vertical: AppDimensions.paddingS,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: app.iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                app.icon,
                color: app.iconColor,
                size: AppDimensions.iconM,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    app.name,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontM,
                      fontWeight: FontWeight.w700,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 2),
                  AppText(
                    app.description,
                    secondary: true,
                    style: const TextStyle(fontSize: AppDimensions.fontS),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.white,
                      size: 14,
                    )
                  : null,
            ),

          ],
        ),
      ),
    );
  }
}

