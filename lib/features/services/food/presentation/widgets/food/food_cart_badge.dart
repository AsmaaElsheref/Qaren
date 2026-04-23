import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/icon_container.dart';
import '../../pages/foodCartPage/food_cart_page.dart';
import '../../providers/food_cart_provider.dart';

/// Cart icon with a live badge showing total items count.
/// Only rebuilds when [foodCartTotalCountProvider] changes.
class FoodCartBadge extends ConsumerWidget {
  const FoodCartBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalCount = ref.watch(foodCartTotalCountProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconContainer(
          icon:  const Icon(
            Icons.shopping_bag_outlined,
            size: 26,
            color: AppColors.textPrimary,
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FoodCartPage()),),
        ),
        if (totalCount > 0)
          Positioned(
            top: -6,
            left: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                '$totalCount',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

