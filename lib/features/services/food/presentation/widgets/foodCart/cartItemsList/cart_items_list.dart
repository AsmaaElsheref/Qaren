import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../../core/constants/app_dimensions.dart';
import '../../../providers/food_providers.dart';
import 'cart_item_card.dart';

/// Scrollable list of cart item cards.
/// Rebuilds when the items list changes (add/remove), but each card's
/// quantity control uses its own family provider for granular rebuilds.
class CartItemsList extends ConsumerWidget {
  const CartItemsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(foodCartItemsProvider);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: AppDimensions.paddingS),
      itemCount: items.length,
      itemBuilder: (context, index) => CartItemCard(item: items[index]),
    );
  }
}

