import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../providers/food_providers.dart';
import 'food_item_card.dart';

class FoodItemList extends ConsumerWidget {
  const FoodItemList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(foodItemsProvider);
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        indent: AppDimensions.paddingM,
        endIndent: AppDimensions.paddingM,
        color: AppColors.border,
      ),
      itemBuilder: (context, index) => FoodItemCard(item: items[index]),
    );
  }
}

