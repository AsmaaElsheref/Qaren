import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../providers/food_providers.dart';
import 'food_stepper_icon_button.dart';

/// Quantity control row: [ − ]  qty  [ + ]
/// Only rebuilds when the specific item quantity changes via family provider.
class CartQuantityControl extends ConsumerWidget {
  const CartQuantityControl({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(foodItemQuantityProvider(itemId));
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FoodStepperIconButton(
            icon: Icons.remove_rounded,
            onTap: () => ref.read(foodCartProvider.notifier).decrement(itemId),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$quantity',
              style: const TextStyle(
                fontSize: AppDimensions.fontM,
                fontWeight: FontWeight.w700,
                fontFamily: 'Cairo',
                color: AppColors.textPrimary,
              ),
            ),
          ),
          FoodStepperIconButton(
            icon: Icons.add_rounded,
            color: AppColors.primary,
            onTap: () {
              final cartState = ref.read(foodCartProvider);
              final item = cartState.items[itemId];
              if (item != null) {
                ref.read(foodCartProvider.notifier).increment(
                      itemId,
                      name: item.name,
                      imageUrl: item.imageUrl,
                      price: item.price,
                    );
              }
            },
          ),
        ],
      ),
    );
  }
}

