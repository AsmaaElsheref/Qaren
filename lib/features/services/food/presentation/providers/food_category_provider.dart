import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/food_local_datasource.dart';
import '../../domain/entities/food_category.dart';

// ── Data layer ───────────────────────────────────────────────────────────────

final _foodDataSourceProvider = Provider<FoodLocalDataSource>(
  (ref) => const FoodLocalDataSourceImpl(),
);

// ── Categories ───────────────────────────────────────────────────────────────

/// All available food categories (static list for now).
final foodCategoriesProvider = Provider<List<FoodCategory>>(
  (ref) => ref.watch(_foodDataSourceProvider).getCategories(),
);

/// Currently selected category ID.
final selectedFoodCategoryProvider = StateProvider<String>(
  (ref) => 'burger',
);

