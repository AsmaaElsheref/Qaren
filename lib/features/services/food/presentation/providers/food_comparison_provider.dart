import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/food_comparison_local_data.dart';
import '../../domain/entities/food_invoice_model.dart';
import '../../domain/entities/food_provider_model.dart';
import '../../domain/entities/food_sort_type.dart';

// ── Sort filter ──────────────────────────────────────────────────────────────

/// Currently selected sort type for comparison.
final foodSortTypeProvider = StateProvider<FoodSortType>(
  (ref) => FoodSortType.suggested,
);

// ── Raw providers list ───────────────────────────────────────────────────────

/// All delivery providers (static dummy data for now).
final foodProvidersListProvider = Provider<List<FoodProviderModel>>(
  (ref) => FoodComparisonLocalData.providers,
);

// ── Sorted providers ─────────────────────────────────────────────────────────

/// Sorted list derived from the raw list + current sort type.
/// Rebuilds only when sort type or the raw list changes.
final sortedFoodProvidersProvider = Provider<List<FoodProviderModel>>((ref) {
  final sort = ref.watch(foodSortTypeProvider);
  final list = List<FoodProviderModel>.from(ref.watch(foodProvidersListProvider));

  switch (sort) {
    case FoodSortType.suggested:
      list.sort((a, b) {
        if (a.isBestValue != b.isBestValue) return a.isBestValue ? -1 : 1;
        return a.price.compareTo(b.price);
      });
    case FoodSortType.cheapest:
      list.sort((a, b) => a.price.compareTo(b.price));
    case FoodSortType.fastest:
      list.sort((a, b) => a.deliveryTimeMinutes.compareTo(b.deliveryTimeMinutes));
  }
  return list;
});

// ── Invoice ──────────────────────────────────────────────────────────────────

/// Invoice data for the order receipt screen.
final foodInvoiceProvider = Provider<FoodInvoiceModel>(
  (ref) => FoodComparisonLocalData.sampleInvoice,
);

