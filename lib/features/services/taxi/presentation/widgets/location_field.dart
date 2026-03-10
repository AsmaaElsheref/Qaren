import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppTextStyles.dart';

class LocationField extends StatelessWidget {
  final String hint;
  final IconData leadingIcon;
  final Color iconColor;
  final Color iconBgColor;
  final String value;
  final VoidCallback onTap;

  const LocationField({
    super.key,
    required this.hint,
    required this.leadingIcon,
    required this.iconColor,
    required this.iconBgColor,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = value.isEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimensions.inputHeight,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
        child: Row(
          children: [
            // Icon badge
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(leadingIcon, color: iconColor, size: AppDimensions.iconS),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            // Label / hint
            Expanded(
              child: Text(
                isEmpty ? hint : value,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: isEmpty
                    ? AppTextStyles.bodySecondary.copyWith(color: AppColors.textHint)
                    : AppTextStyles.body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
