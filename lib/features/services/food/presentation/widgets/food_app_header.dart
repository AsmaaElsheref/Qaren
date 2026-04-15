import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/icon_container.dart';
import 'package:qaren/features/services/food/presentation/food_strings.dart';
import 'package:qaren/features/services/food/presentation/widgets/food_cart_badge.dart';
import 'package:qaren/features/services/food/presentation/widgets/food_menu_badge.dart';

/// Top header row with cart icon + badge, title, and menu icon + badge.
class FoodAppHeader extends StatelessWidget {
  const FoodAppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      child: Row(
        children: [
          IconContainer(
            onTap: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              size: AppDimensions.iconS,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingS),
          AppText(FoodStrings.pageTitle,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          const Spacer(),
          const FoodMenuBadge(),
          const SizedBox(width: AppDimensions.paddingM),
          const FoodCartBadge(),
        ],
      ),
    );
  }
}

