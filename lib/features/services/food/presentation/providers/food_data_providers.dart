import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/food_local_datasource.dart';
import '../../data/datasources/food_remote_datasource.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/restaurant.dart';

// ── Data layer ───────────────────────────────────────────────────────────────

final foodRemoteDataSourceProvider = Provider<FoodRemoteDataSource>(
  (ref) => const FoodRemoteDataSourceImpl(),
);

final _foodLocalDataSourceProvider = Provider<FoodLocalDataSource>(
  (ref) => const FoodLocalDataSourceImpl(),
);

// ── All products from API ────────────────────────────────────────────────────

/// Fetches all food products from the API once.
final allFoodProductsProvider = FutureProvider<List<FoodItem>>((ref) {
  return ref.watch(foodRemoteDataSourceProvider).getProducts();
});

// ── Search query ─────────────────────────────────────────────────────────────

/// Current search text entered by user.
final foodSearchQueryProvider = StateProvider<String>(
  (ref) => '',
);

/// Currently selected category ID.
final selectedFoodCategoryProvider = StateProvider<String>(
  (ref) => 'all',
);

// ── Restaurant (still from local for now) ────────────────────────────────────

/// The featured restaurant for the selected category.
final foodRestaurantProvider = Provider<Restaurant>(
  (ref) {
    final categoryId = ref.watch(selectedFoodCategoryProvider);
    return ref.watch(_foodLocalDataSourceProvider).getRestaurant(categoryId);
  },
);

