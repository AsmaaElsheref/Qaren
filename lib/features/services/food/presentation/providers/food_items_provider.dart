import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/food_local_datasource.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/restaurant.dart';
import 'food_category_provider.dart';

// ── Data layer ───────────────────────────────────────────────────────────────

final _foodDataSourceProvider = Provider<FoodLocalDataSource>(
  (ref) => const FoodLocalDataSourceImpl(),
);

// ── Restaurant ───────────────────────────────────────────────────────────────

/// The featured restaurant for the selected category.
final foodRestaurantProvider = Provider<Restaurant>(
  (ref) {
    final categoryId = ref.watch(selectedFoodCategoryProvider);
    return ref.watch(_foodDataSourceProvider).getRestaurant(categoryId);
  },
);

// ── Food items ───────────────────────────────────────────────────────────────

/// Food items for the selected category.
final foodItemsProvider = Provider<List<FoodItem>>(
  (ref) {
    final categoryId = ref.watch(selectedFoodCategoryProvider);
    return ref.watch(_foodDataSourceProvider).getFoodItems(categoryId);
  },
);

