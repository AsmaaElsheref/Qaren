import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../food_strings.dart';

/// Empty cart state view with a large icon and "السلة فارغة" text.
class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 44,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          AppText(
            FoodStrings.emptyCart,
            style: const TextStyle(
              fontSize: AppDimensions.fontL,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

