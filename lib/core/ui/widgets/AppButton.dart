import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';
import '../../theme/app_colors.dart';
import 'AppText.dart';

/// A full-width primary gradient button with optional loading state.
///
/// - [label]     : button text
/// - [onTap]     : callback; pass `null` to disable the button
/// - [isLoading] : shows a [CircularProgressIndicator] instead of label
/// - [icon]      : optional trailing icon (default: arrow_forward_rounded)
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final IconData icon;

  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.icon = Icons.arrow_forward_rounded,
  });

  bool get _enabled => onTap != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _enabled ? null : AppColors.textHint.withValues(alpha: 0.4),
          gradient: _enabled ? AppColors.primaryGradient : null,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: _enabled
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
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
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

