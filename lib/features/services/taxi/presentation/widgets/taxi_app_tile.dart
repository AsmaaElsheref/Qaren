import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/features/services/taxi/presentation/providers/taxi_apps/taxi_app_model.dart';

/// A single selectable row for one taxi app.
/// Purely presentational — receives data and callbacks only.
/// When [isSelected] is false the tile renders in a muted/disabled state
/// using the theme disabled tokens, matching the category card pattern.
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
    final colors = context.appColors;

    // ── Resolved token values ──────────────────────────────────────────────
    final cardColor =
        isSelected ? colors.card : colors.disabledBackground;
    final borderColor =
        isSelected ? AppColors.primary : colors.border.withValues(alpha: 0.4);
    final iconBgColor =
        isSelected ? app.iconBgColor : colors.disabledBackground;
    final iconColor =
        isSelected ? app.iconColor : colors.disabledText;
    final titleColor =
        isSelected ? colors.textPrimary : colors.disabledText;
    final descColor = isSelected
        ? colors.textSecondary
        : colors.disabledText.withValues(alpha: 0.7);

    return Opacity(
      opacity: isSelected ? 1.0 : 0.55,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: isSelected ? colors.shadow : Colors.transparent,
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
              // ── App icon ─────────────────────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  app.icon,
                  color: iconColor,
                  size: AppDimensions.iconM,
                ),
              ),

              const SizedBox(width: AppDimensions.paddingM),

              // ── Name + description ────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      app.name,
                      style: TextStyle(
                        fontSize: AppDimensions.fontM,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 2),
                    AppText(
                      app.description,
                      secondary: true,
                      style: TextStyle(
                        fontSize: AppDimensions.fontS,
                        color: descColor,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppDimensions.paddingM),

              // ── Selection indicator ───────────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : colors.border,
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
      ),
    );
  }
}
