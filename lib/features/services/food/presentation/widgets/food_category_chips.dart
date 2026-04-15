import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../providers/food_providers.dart';
import 'food_category_chip.dart';

class FoodCategoryChips extends ConsumerWidget {
  const FoodCategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(foodCategoriesProvider);
    final selectedId = ref.watch(selectedFoodCategoryProvider);
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
        ),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.paddingS),
        itemBuilder: (context, index) {
          final category = categories[index];
          return FoodCategoryChip(
            category: category,
            isSelected: category.id == selectedId,
            onTap: () => ref.read(selectedFoodCategoryProvider.notifier).state = category.id,
          );
        },
      ),
    );
  }
}