import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_item.dart';
import 'food_data_providers.dart';

// ── Filtered food items (by category + search) ──────────────────────────────

/// Food items filtered by selected category and search query.
/// This is the main provider the UI should watch for displaying items.
final foodItemsProvider = Provider<AsyncValue<List<FoodItem>>>((ref) {
  final asyncProducts = ref.watch(allFoodProductsProvider);
  final selectedCategory = ref.watch(selectedFoodCategoryProvider);
  final searchQuery = ref.watch(foodSearchQueryProvider).trim().toLowerCase();

  return asyncProducts.whenData((products) {
    var filtered = products;

    // Filter by category if not "all"
    if (selectedCategory != 'all') {
      filtered = filtered
          .where((item) =>
              item.categoryNameAr == selectedCategory ||
              item.categoryNameEn.toLowerCase() == selectedCategory.toLowerCase() ||
              item.categoryId == selectedCategory)
          .toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((item) =>
              item.name.toLowerCase().contains(searchQuery) ||
              item.description.toLowerCase().contains(searchQuery) ||
              item.shortDescription.toLowerCase().contains(searchQuery) ||
              item.categoryNameAr.contains(searchQuery) ||
              item.categoryNameEn.toLowerCase().contains(searchQuery))
          .toList();
    }

    return filtered;
  });
});

