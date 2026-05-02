import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../food_strings.dart';
import '../../providers/food_providers.dart';
import 'checkout_item_card.dart';

/// Items list section. Watches only [checkoutItemsProvider] so it stays
/// isolated from unrelated state (notes, payment, etc.).
class CheckoutItemsList extends ConsumerWidget {
  const CheckoutItemsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(checkoutItemsProvider);
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
            child: AppText(
              FoodStrings.orderItemsSection,
              style: TextStyle(
                fontSize: AppDimensions.fontM,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          for (int i = 0; i < items.length; i++) ...[
            CheckoutItemCard(item: items[i]),
            if (i != items.length - 1)
              const Divider(height: 1, color: AppColors.border),
          ],
        ],
      ),
    );
  }
}

