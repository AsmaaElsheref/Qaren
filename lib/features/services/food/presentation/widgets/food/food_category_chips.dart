import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../providers/food_data_providers.dart';
import 'food_category_chip.dart';
import 'food_category_chips_shimmer.dart';

/// Horizontally scrollable category filter chips.
///
/// Categories are fetched from the API via [foodCategoriesProvider].
/// Selecting a chip updates [selectedFoodCategoryProvider], which causes
/// [foodItemsProvider] to re-fetch with `?category_id=<id>`.
class FoodCategoryChips extends ConsumerWidget {
  const FoodCategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCategories = ref.watch(foodCategoriesProvider);
    final selectedId = ref.watch(selectedFoodCategoryProvider);

    return SizedBox(
      height: 34,
      child: asyncCategories.when(
        loading: () => const FoodCategoryChipsShimmer(),
        error: (_, __) => const SizedBox.shrink(),
        data: (categories) => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
          ),
          itemCount: categories.length,
          separatorBuilder: (_, __) =>
              const SizedBox(width: AppDimensions.paddingS),
          itemBuilder: (context, index) {
            final category = categories[index];
            return FoodCategoryChip(
              category: category,
              isSelected: category.id == selectedId,
              onTap: () {
                ref.read(selectedFoodCategoryProvider.notifier).state =
                    category.id;
              },
            );
          },
        ),
      ),
    );
  }
}