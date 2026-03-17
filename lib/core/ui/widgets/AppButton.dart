import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';
import '../../theme/app_colors.dart';
import 'AppText.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final IconData icon;
  final double? width;
  final double? height;
  final Color? color;
  final double? radius;
  final bool? removeShadow;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.icon = Icons.arrow_forward_rounded, this.width, this.height, this.color, this.radius, this.removeShadow,
  });

  bool get _enabled => onTap != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width??double.infinity,
      height: height??AppDimensions.buttonHeight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _enabled ? null : AppColors.textHint.withValues(alpha: 0.4),
          gradient: _enabled ? AppColors.primaryGradient : null,
          borderRadius: BorderRadius.circular(radius??AppDimensions.radiusL),
          boxShadow: _enabled&&removeShadow!=true
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
          color: color??Colors.transparent,
          borderRadius: BorderRadius.circular(radius??0),
          child: InkWell(
            borderRadius: BorderRadius.circular(radius??AppDimensions.radiusL),
            onTap: _enabled ? onTap : null,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(
                          label,
                          style: const TextStyle(
                            fontSize: AppDimensions.fontM,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.paddingS),
                        Icon(
                          icon,
                          size: AppDimensions.iconS,
                          color: AppColors.white,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

