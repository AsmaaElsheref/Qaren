import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'taxi_state.dart';

class TaxiNotifier extends Notifier<TaxiState> {
  @override
  TaxiState build() => const TaxiState();

  void setPickup(String value) =>
      state = state.copyWith(pickup: value, clearPickupLatLng: true);

  void setDestination(String value) =>
      state = state.copyWith(destination: value, clearDestinationLatLng: true);

  void confirmLocation({
    required TaxiActiveField field,
    required LatLng latLng,
    required String label,
  }) {
    if (field == TaxiActiveField.pickup) {
      state = state.copyWith(pickup: label, pickupLatLng: latLng);
    } else {
      state = state.copyWith(destination: label, destinationLatLng: latLng);
    }
  }

  Future<String?> useCurrentLocation(TaxiActiveField field,latLng,label) async {
    try {
      confirmLocation(field: field, latLng: latLng, label: label);
      return null;
    } finally {
      state = state.copyWith(isLocationLoading: false);
    }
  }

  Future<void> comparePrices() async {
    if (state.pickup.isEmpty || state.destination.isEmpty) return;
    state = state.copyWith(isLoading: true);
    // TODO: call actual price-comparison use-case
    await Future<void>.delayed(const Duration(seconds: 2));
    state = state.copyWith(isLoading: false);
  }
}

/// Global provider for the taxi notifier.
final taxiProvider = NotifierProvider<TaxiNotifier, TaxiState>(TaxiNotifier.new);

