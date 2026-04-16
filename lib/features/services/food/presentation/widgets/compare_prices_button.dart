import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/ui/widgets/AppButton.dart';
import '../food_strings.dart';
import '../providers/food_providers.dart';
import 'foodLoading/food_loading.dart';

/// CTA button at the bottom of the cart page.
/// Disabled when the cart is empty, enabled when items exist.
/// Only rebuilds when [foodCartIsEmptyProvider] changes.
class ComparePricesButton extends ConsumerWidget {
  const ComparePricesButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmpty = ref.watch(foodCartIsEmptyProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AppButton(
        label: FoodStrings.comparePrices,
        icon: Icons.directions_bike,
        onTap: isEmpty ? null : () => Navigator.push(context, MaterialPageRoute(builder: (context) => Searching(),)),
      ),
    );
  }
}

