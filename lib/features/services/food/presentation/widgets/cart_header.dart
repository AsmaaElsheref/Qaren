import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../food_strings.dart';
import 'cart_close_button.dart';
import 'cart_icon_badge.dart';
import 'cart_items_count.dart';

/// Top header row for the cart page:
/// [X close]  ...  [title + count]  ...  [cart icon]
class CartHeader extends StatelessWidget {
  const CartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      child: Row(
        children: [
          const CartCloseButton(),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                FoodStrings.orderSummary,
                style: const TextStyle(
                  fontSize: AppDimensions.fontL,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const CartItemsCount(),
            ],
          ),
          const Spacer(),
          const CartIconBadge(),
        ],
      ),
    );
  }
}

