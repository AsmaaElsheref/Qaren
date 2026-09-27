import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_colors_ext.dart';
import 'AppText.dart';

class AppButton extends StatelessWidget {
  final String label;
  final Widget? labelWidget;
  final VoidCallback? onTap;
  final bool isLoading;
  final IconData icon;
  final double? width;
  final double? height;
  final Color? color;
  final Color? foregroundColor;
  final double? radius;
  final bool? removeShadow;

  const AppButton({
    super.key,
    required this.label,
    this.labelWidget,
    required this.onTap,
    this.isLoading = false,
    this.icon = Icons.arrow_forward_rounded,
    this.width,
    this.height,
    this.color,
    this.foregroundColor,
    this.radius,
    this.removeShadow,
  });

  bool get _enabled => onTap != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final useActiveStyle = onTap != null || isLoading;
    final effectiveForegroundColor = !_enabled && !isLoading
        ? colors.textSecondary
        : foregroundColor ??
              (color == null ? AppColors.onPrimary : AppColors.white);
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppDimensions.buttonHeight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: useActiveStyle ? null : colors.disabledBackground,
          gradient: useActiveStyle ? AppColors.primaryGradient : null,
          borderRadius: BorderRadius.circular(radius ?? AppDimensions.radiusL),
          boxShadow: useActiveStyle && removeShadow != true
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: color ?? Colors.transparent,
          borderRadius: BorderRadius.circular(radius ?? 0),
          child: InkWell(
            borderRadius: BorderRadius.circular(
              radius ?? AppDimensions.radiusL,
            ),
            onTap: _enabled ? onTap : null,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: effectiveForegroundColor,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            labelWidget ??
                                AppText(
                                  label,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: AppDimensions.fontM,
                                    fontWeight: FontWeight.w700,
                                    color: effectiveForegroundColor,
                                  ),
                                ),
                            const SizedBox(width: AppDimensions.paddingS),
                            Icon(
                              icon,
                              size: AppDimensions.iconS,
                              color: effectiveForegroundColor,
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
