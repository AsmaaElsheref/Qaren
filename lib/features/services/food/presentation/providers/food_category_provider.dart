import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/food_category.dart';
import 'food_data_providers.dart';

// ── Categories derived from API ──────────────────────────────────────────────

/// All available food categories extracted from API products.
/// Includes "الكل" as the first entry.
final foodCategoriesProvider = Provider<List<FoodCategory>>((ref) {
  final asyncProducts = ref.watch(allFoodProductsProvider);
  return asyncProducts.when(
    data: (products) {
      final seen = <String>{};
      final categories = <FoodCategory>[
        const FoodCategory(id: 'all', name: 'الكل'),
      ];
      for (final item in products) {
        final key = item.categoryId;
        if (key.isNotEmpty && seen.add(key)) {
          categories.add(FoodCategory(
            id: key,
            name: item.categoryNameAr.isNotEmpty
                ? item.categoryNameAr
                : item.categoryNameEn,
          ));
        }
      }
      return categories;
    },
    loading: () => const [FoodCategory(id: 'all', name: 'الكل')],
    error: (_, __) => const [FoodCategory(id: 'all', name: 'الكل')],
  );
});

