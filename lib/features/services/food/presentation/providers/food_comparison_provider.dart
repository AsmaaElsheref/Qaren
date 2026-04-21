import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/models/food_compare_request_model.dart';
import '../../domain/entities/food_invoice_model.dart';
import '../../domain/entities/food_provider_model.dart';
import '../../domain/entities/food_sort_type.dart';
import 'food_data_providers.dart';

// ── User-selected location for comparison ─────────────────────────────────────

/// Holds the LatLng the user confirmed in the location picker sheet.
/// Null until the user picks a location.
final foodSelectedLocationProvider = StateProvider<LatLng?>((ref) => null);

// ── Sort filter ──────────────────────────────────────────────────────────────

/// Currently selected sort type for comparison.
final foodSortTypeProvider = StateProvider<FoodSortType>(
  (ref) => FoodSortType.suggested,
);

// ── Compare result state ──────────────────────────────────────────────────────

/// Holds the raw partner list returned by the compare API.
/// Populated by [FoodCompareNotifier].
class FoodCompareState {
  final List<FoodProviderModel> partners;
  final bool isLoading;
  final String? error;

  const FoodCompareState({
    this.partners = const [],
    this.isLoading = false,
    this.error,
  });

  FoodCompareState copyWith({
    List<FoodProviderModel>? partners,
    bool? isLoading,
    String? error,
  }) =>
      FoodCompareState(
        partners: partners ?? this.partners,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class FoodCompareNotifier extends Notifier<FoodCompareState> {
  @override
  FoodCompareState build() => const FoodCompareState();

  Future<void> compare({
    required List<int> productIds,
    required double userLat,
    required double userLng,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final dataSource = ref.read(foodRemoteDataSourceProvider);
      final result = await dataSource.compareProducts(
        FoodCompareRequestModel(
          productIds: productIds,
          userLat: userLat,
          userLng: userLng,
        ),
      );
      state = state.copyWith(isLoading: false, partners: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final foodCompareNotifierProvider =
    NotifierProvider<FoodCompareNotifier, FoodCompareState>(
  FoodCompareNotifier.new,
);

// ── Raw providers list ───────────────────────────────────────────────────────

/// All delivery providers from the compare API result.
final foodProvidersListProvider = Provider<List<FoodProviderModel>>(
  (ref) => ref.watch(foodCompareNotifierProvider).partners,
);

// ── Sorted providers ─────────────────────────────────────────────────────────

/// Sorted list derived from the raw list + current sort type.
final sortedFoodProvidersProvider = Provider<List<FoodProviderModel>>((ref) {
  final sort = ref.watch(foodSortTypeProvider);
  final list = List<FoodProviderModel>.from(ref.watch(foodProvidersListProvider));

  switch (sort) {
    case FoodSortType.suggested:
      list.sort((a, b) {
        if (a.isBestValue != b.isBestValue) return a.isBestValue ? -1 : 1;
        if (a.isCheapest != b.isCheapest) return a.isCheapest ? -1 : 1;
        return a.price.compareTo(b.price);
      });
    case FoodSortType.cheapest:
      list.sort((a, b) => a.price.compareTo(b.price));
    case FoodSortType.fastest:
      list.sort((a, b) =>
          a.deliveryTimeMinutes.compareTo(b.deliveryTimeMinutes));
  }
  return list;
});

/// Whether a compare API call is in progress.
final foodCompareIsLoadingProvider = Provider<bool>(
  (ref) => ref.watch(foodCompareNotifierProvider).isLoading,
);

/// Error message from last compare call, or null.
final foodCompareErrorProvider = Provider<String?>(
  (ref) => ref.watch(foodCompareNotifierProvider).error,
);

// ── Invoice ──────────────────────────────────────────────────────────────────

/// Invoice data for the order receipt screen (still static until order API).
final foodInvoiceProvider = Provider<FoodInvoiceModel>(
  (ref) => const FoodInvoiceModel(
    fromLocation: '',
    toLocation: '',
    distance: '',
    deliveryTimeMinutes: 0,
    itemsCount: 0,
    orderTime: '',
    date: '',
  ),
);

