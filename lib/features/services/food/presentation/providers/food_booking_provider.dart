import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/food_booking_request_model.dart';
import '../../data/models/food_booking_response.dart'; // FoodBookingResponse
import '../../domain/entities/food_provider_model.dart';
import 'food_cart_provider.dart';
import 'food_comparison_provider.dart';
import 'food_data_providers.dart';

/// State of the booking submit call.
class FoodBookingState {
  const FoodBookingState({
    this.isLoading = false,
    this.error,
    this.result,
  });

  final bool isLoading;
  final String? error;
  final FoodBookingResponse? result;

  FoodBookingState copyWith({
    bool? isLoading,
    String? error,
    FoodBookingResponse? result,
  }) =>
      FoodBookingState(
        isLoading: isLoading ?? this.isLoading,
        error: error,
        result: result ?? this.result,
      );
}

/// Submits POST /api/compare/booking using:
/// - the selected partner from the comparison flow
/// - the user-selected delivery location
/// - the current cart items (each carrying its own
///   `food_product_warehouse_id` from branch selection)
class FoodBookingNotifier extends Notifier<FoodBookingState> {
  @override
  FoodBookingState build() => const FoodBookingState();

  /// Builds the booking body and submits it.
  ///
  /// [partner] is the restaurant the user picked from the comparison
  /// screen. For partial-match restaurants, only items present in
  /// [partner.productsPreview] are sent.
  ///
  /// [deliveryAddress] / [deliveryLat] / [deliveryLng] come from the
  /// existing location-picker flow.
  Future<bool> submit({
    required FoodProviderModel partner,
    required String deliveryAddress,
    required double deliveryLat,
    required double deliveryLng,
    String paymentMethod = 'cash',
    String customerNotes = '',
    String? couponCode,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final cart = ref.read(foodCartProvider).items.values;
    final partnerId = int.tryParse(partner.id) ?? 0;

    final isPartial = partner.totalRequested > 0 &&
        partner.matchedCount < partner.totalRequested;

    final allowedIds = isPartial
        ? partner.productsPreview.map((p) => p.id).toSet()
        : null;

    final body = FoodBookingRequestModel.fromCart(
      mainPartnerId: partnerId,
      cartItems: cart,
      deliveryAddress: deliveryAddress,
      deliveryLat: deliveryLat,
      deliveryLng: deliveryLng,
      allowedProductIds: allowedIds,
      paymentMethod: paymentMethod,
      customerNotes: customerNotes,
      couponCode: couponCode,
    );

    if (body.items.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        error: 'لا يمكن إنشاء الطلب: لم يتم تحديد فرع لأي عنصر في السلة.',
      );
      return false;
    }

    try {
      final result =
          await ref.read(foodRemoteDataSourceProvider).createBooking(body);
      state = state.copyWith(isLoading: false, result: result);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Convenience overload that pulls partner + location from existing
  /// providers — keeps call sites at the UI layer minimal.
  Future<bool> submitForSelectedPartner({
    String paymentMethod = 'cash',
    String customerNotes = '',
    String? couponCode,
  }) async {
    final partner = ref.read(selectedProviderForBookingProvider);
    final location = ref.read(foodSelectedLocationProvider);
    final address = ref.read(foodSelectedLocationNameProvider);

    if (partner == null || location == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'الرجاء اختيار المطعم وعنوان التوصيل قبل إنشاء الطلب.',
      );
      return false;
    }

    return submit(
      partner: partner,
      deliveryAddress: address,
      deliveryLat: location.latitude,
      deliveryLng: location.longitude,
      paymentMethod: paymentMethod,
      customerNotes: customerNotes,
      couponCode: couponCode,
    );
  }

  void reset() => state = const FoodBookingState();
}

final foodBookingProvider =
    NotifierProvider<FoodBookingNotifier, FoodBookingState>(
  FoodBookingNotifier.new,
);

// ── Granular selectors ───────────────────────────────────────────────────────

final foodBookingIsLoadingProvider = Provider<bool>(
  (ref) => ref.watch(foodBookingProvider.select((s) => s.isLoading)),
);

final foodBookingErrorProvider = Provider<String?>(
  (ref) => ref.watch(foodBookingProvider.select((s) => s.error)),
);

/// The successful booking response, or null until the call completes.
final foodBookingResultProvider = Provider<FoodBookingResponse?>(
  (ref) => ref.watch(foodBookingProvider.select((s) => s.result)),
);

