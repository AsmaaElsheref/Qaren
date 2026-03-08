import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';

/// Reusable RTL location input row used for both pickup and destination.
///
/// Accepts [value] for display and [onChanged] for state updates.
/// Kept as [StatelessWidget] — the parent decides when to rebuild via selectors.
class LocationField extends StatelessWidget {
  final String hint;
  final IconData leadingIcon;   // right side (RTL)
  final Color iconColor;
  final Color iconBgColor;
  final String value;
  final ValueChanged<String> onChanged;

  const LocationField({
    super.key,
    required this.hint,
    required this.leadingIcon,
    required this.iconColor,
    required this.iconBgColor,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
      ),
      child: Row(
        // RTL: leading icon on the right, text expands to the left
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
          // Text field expands
          Expanded(
            child: TextField(
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: AppDimensions.fontM,
                color: AppColors.textPrimary,
                fontFamily: 'Cairo',
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: AppDimensions.fontM,
                  color: AppColors.textHint,
                  fontFamily: 'Cairo',
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

