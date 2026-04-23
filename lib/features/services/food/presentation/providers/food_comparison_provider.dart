import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../data/models/food_compare_request_model.dart';
import '../../domain/entities/food_invoice_detail.dart';
import '../../domain/entities/food_invoice_model.dart';
import '../../domain/entities/food_provider_model.dart';
import '../../domain/entities/food_sort_type.dart';
import 'food_cart_provider.dart';
import 'food_data_providers.dart';

// ── User-selected location for comparison ────────────────────────────────────

/// Holds the LatLng the user confirmed in the location picker sheet.
/// Null until the user picks a location.
final foodSelectedLocationProvider = StateProvider<LatLng?>((ref) => null);

/// Human-readable address name resolved from the picked location.
/// Updated alongside [foodSelectedLocationProvider].
final foodSelectedLocationNameProvider = StateProvider<String>((ref) => '');

// ── Sort filter ──────────────────────────────────────────────────────────────

/// Currently selected sort type for comparison.
final foodSortTypeProvider = StateProvider<FoodSortType>(
  (ref) => FoodSortType.suggested,
);

// ── Selected provider for booking ────────────────────────────────────────────

/// Set just before navigating to the invoice page.
/// Null until the user taps "اطلب الآن" / "اطلب المتوفر" on a provider card.
final selectedProviderForBookingProvider =
    StateProvider<FoodProviderModel?>((ref) => null);

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
  final list =
      List<FoodProviderModel>.from(ref.watch(foodProvidersListProvider));

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
      list.sort(
          (a, b) => a.deliveryTimeMinutes.compareTo(b.deliveryTimeMinutes));
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

/// Derives a real [FoodInvoiceModel] from:
/// - the selected provider (set before navigating to the invoice page)
/// - matched items count for that restaurant  → used as itemsCount
/// - selected user location                  → shown as destination
/// - current date / time
final foodInvoiceProvider = Provider<FoodInvoiceModel>((ref) {
  final provider      = ref.watch(selectedProviderForBookingProvider);
  final cartState     = ref.watch(foodCartProvider);
  final locationName  = ref.watch(foodSelectedLocationNameProvider);

  final now      = DateTime.now();
  final dateStr  = DateFormat('dd/MM/yyyy').format(now);
  final timeStr  = DateFormat('hh:mm a').format(now);

  // itemsCount = how many products this restaurant actually provides.
  // Falls back to total cart count if no provider is selected yet.
  final itemsCount = (provider != null && provider.matchedCount > 0)
      ? provider.matchedCount
      : cartState.totalCount;

  final toLocation = locationName.isNotEmpty ? locationName : 'موقعك';

  return FoodInvoiceModel(
    provider: provider,
    fromLocation: provider?.name ?? '',
    toLocation: toLocation,
    distance: provider?.distanceKm != null
        ? '${provider!.distanceKm!.toStringAsFixed(1)} كم'
        : '',
    deliveryTimeMinutes: provider?.deliveryTimeMinutes ?? 0,
    itemsCount: itemsCount,
    orderTime: timeStr,
    date: dateStr,
  );
});

// ── Invoice detail (single-partner API) ──────────────────────────────────────

/// State for the invoice detail async call.
class FoodInvoiceDetailState {
  const FoodInvoiceDetailState({
    this.detail,
    this.isLoading = false,
    this.error,
  });

  final FoodInvoiceDetail? detail;
  final bool isLoading;
  final String? error;

  FoodInvoiceDetailState copyWith({
    FoodInvoiceDetail? detail,
    bool? isLoading,
    String? error,
  }) =>
      FoodInvoiceDetailState(
        detail: detail ?? this.detail,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

/// Fetches the full invoice detail from
/// GET /api/food-products/compare/{partnerId}?product_ids[]=...
class FoodInvoiceDetailNotifier extends Notifier<FoodInvoiceDetailState> {
  @override
  FoodInvoiceDetailState build() => const FoodInvoiceDetailState();

  Future<void> fetch({
    required int partnerId,
    required List<int> productIds,
    required double userLat,
    required double userLng,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final detail = await ref
          .read(foodRemoteDataSourceProvider)
          .getInvoiceDetail(
            partnerId: partnerId,
            productIds: productIds,
            userLat: userLat,
            userLng: userLng,
          );
      state = state.copyWith(isLoading: false, detail: detail);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final foodInvoiceDetailProvider =
    NotifierProvider<FoodInvoiceDetailNotifier, FoodInvoiceDetailState>(
  FoodInvoiceDetailNotifier.new,
);

/// Convenience granular providers — small rebuild scope.
final foodInvoiceDetailIsLoadingProvider = Provider<bool>(
  (ref) => ref.watch(foodInvoiceDetailProvider).isLoading,
);

final foodInvoiceDetailErrorProvider = Provider<String?>(
  (ref) => ref.watch(foodInvoiceDetailProvider).error,
);

final foodInvoiceDetailDataProvider = Provider<FoodInvoiceDetail?>(
  (ref) => ref.watch(foodInvoiceDetailProvider).detail,
);
