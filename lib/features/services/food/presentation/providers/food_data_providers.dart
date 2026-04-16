import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/food_local_datasource.dart';
import '../../data/datasources/food_remote_datasource.dart';
import '../../domain/entities/food_category.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/restaurant.dart';

// ── Data sources ─────────────────────────────────────────────────────────────

final foodRemoteDataSourceProvider = Provider<FoodRemoteDataSource>(
  (ref) => const FoodRemoteDataSourceImpl(),
);

final _foodLocalDataSourceProvider = Provider<FoodLocalDataSource>(
  (ref) => const FoodLocalDataSourceImpl(),
);

// ── Base state providers ──────────────────────────────────────────────────────

/// Currently selected category ID.
/// 'all' = no category filter; otherwise the numeric string id from the API.
final selectedFoodCategoryProvider = StateProvider<String>(
  (ref) => 'all',
);

/// The debounced search query that actually triggers an API call.
/// Updated by [FoodSearchField] after a 500 ms debounce.
final foodSearchQueryProvider = StateProvider<String>(
  (ref) => '',
);

// ── Categories — fetched from API ─────────────────────────────────────────────

/// All food categories prepended with "الكل" (all).
/// Fetched once; used to build category filter chips.
final foodCategoriesProvider = FutureProvider<List<FoodCategory>>((ref) async {
  final dataSource = ref.watch(foodRemoteDataSourceProvider);
  final categories = await dataSource.getCategories();
  return [
    const FoodCategory(id: 'all', name: 'الكل'),
    ...categories,
  ];
});

// ── Products — server-side search + category filter ──────────────────────────

/// Food products from the API filtered by the selected category and/or
/// a search query.
///
/// Rebuild scope: only rebuilds when [selectedFoodCategoryProvider] or
/// [foodSearchQueryProvider] change — not on every keystroke because
/// [FoodSearchField] debounces updates to [foodSearchQueryProvider].
final foodItemsProvider = FutureProvider<List<FoodItem>>((ref) {
  final categoryId = ref.watch(selectedFoodCategoryProvider);
  final search     = ref.watch(foodSearchQueryProvider);

  return ref.watch(foodRemoteDataSourceProvider).getProducts(
    search:     search.isEmpty     ? null : search,
    categoryId: categoryId == 'all' ? null : categoryId,
  );
});

// ── Restaurant — still served from local dummy data ──────────────────────────

final foodRestaurantProvider = Provider<Restaurant>((ref) {
  final categoryId = ref.watch(selectedFoodCategoryProvider);
  return ref.watch(_foodLocalDataSourceProvider).getRestaurant(categoryId);
});
