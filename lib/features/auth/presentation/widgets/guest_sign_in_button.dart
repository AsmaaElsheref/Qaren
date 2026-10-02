import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_colors_ext.dart';
import '../../../../core/ui/widgets/AppText.dart';

class GuestSignInButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const GuestSignInButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: colors.border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    label,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: AppDimensions.fontM,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingS),
                  const Icon(Icons.explore_outlined),
                ],
              ),
      ),
    );
  }
}
