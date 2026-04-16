import 'package:flutter/material.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../food_strings.dart';

/// Dashed "إضافة المزيد" button below the cart items list.
class AddMoreButton extends StatelessWidget {
  const AddMoreButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).pop(),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.paddingM,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: AppColors.border,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_rounded,
              size: 20,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppDimensions.paddingS),
            AppText(
              FoodStrings.addMore,
              style: const TextStyle(
                fontSize: AppDimensions.fontM,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

