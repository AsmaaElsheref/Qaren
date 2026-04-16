import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../food_strings.dart';
import '../providers/food_providers.dart';

/// Shows "{count} عناصر" under the title.
/// Only rebuilds when [foodCartTotalCountProvider] changes.
class CartItemsCount extends ConsumerWidget {
  const CartItemsCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(foodCartTotalCountProvider);

    return AppText(
      '$count ${FoodStrings.itemsCount}',
      style: const TextStyle(
        fontSize: 13,
        color: AppColors.textSecondary,
      ),
    );
  }
}

