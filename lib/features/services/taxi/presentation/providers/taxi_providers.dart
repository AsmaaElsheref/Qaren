import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ── Which field is currently being edited ────────────────────────────────────
enum TaxiActiveField { pickup, destination }

// ── State ────────────────────────────────────────────────────────────────────

/// Default camera — Cairo, Egypt
const _kInitialPosition = LatLng(30.0444, 31.2357);

class TaxiState {
  final String pickup;
  final String destination;
  final bool isLoading;
  final LatLng? pickupLatLng;
  final LatLng? destinationLatLng;

  const TaxiState({
    this.pickup = '',
    this.destination = '',
    this.isLoading = false,
    this.pickupLatLng,
    this.destinationLatLng,
  });

  TaxiState copyWith({
    String? pickup,
    String? destination,
    bool? isLoading,
    LatLng? pickupLatLng,
    LatLng? destinationLatLng,
    bool clearPickupLatLng = false,
    bool clearDestinationLatLng = false,
  }) =>
      TaxiState(
        pickup: pickup ?? this.pickup,
        destination: destination ?? this.destination,
        isLoading: isLoading ?? this.isLoading,
        pickupLatLng: clearPickupLatLng ? null : (pickupLatLng ?? this.pickupLatLng),
        destinationLatLng: clearDestinationLatLng ? null : (destinationLatLng ?? this.destinationLatLng),
      );

  Set<Marker> get markers => {
        if (pickupLatLng != null)
          Marker(
            markerId: const MarkerId('pickup'),
            position: pickupLatLng!,
            infoWindow: InfoWindow(title: pickup.isNotEmpty ? pickup : 'نقطة الانطلاق'),
          ),
        if (destinationLatLng != null)
          Marker(
            markerId: const MarkerId('destination'),
            position: destinationLatLng!,
            infoWindow: InfoWindow(title: destination.isNotEmpty ? destination : 'الوجهة'),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
      };
}

// ── Notifier ─────────────────────────────────────────────────────────────────

class TaxiNotifier extends Notifier<TaxiState> {
  @override
  TaxiState build() => const TaxiState();

  void setPickup(String value) =>
      state = state.copyWith(pickup: value, clearPickupLatLng: true);

  void setDestination(String value) =>
      state = state.copyWith(destination: value, clearDestinationLatLng: true);

  /// Called when user confirms a location from map or current-location picker.
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

  Future<void> comparePrices() async {
    if (state.pickup.isEmpty || state.destination.isEmpty) return;
    state = state.copyWith(isLoading: true);
    // TODO: call actual price-comparison use-case
    await Future<void>.delayed(const Duration(seconds: 2));
    state = state.copyWith(isLoading: false);
  }
}

final taxiProvider =
    NotifierProvider<TaxiNotifier, TaxiState>(TaxiNotifier.new);

// ── Granular selectors ────────────────────────────────────────────────────────

/// True only when the compare button should be active.
final taxiCanCompareProvider = Provider<bool>(
  (ref) => ref.watch(
    taxiProvider.select((s) => s.pickup.isNotEmpty && s.destination.isNotEmpty),
  ),
);

final taxiIsLoadingProvider = Provider<bool>(
  (ref) => ref.watch(taxiProvider.select((s) => s.isLoading)),
);

/// Markers set — rebuilds only when pickup/destination LatLng changes.
final taxiMarkersProvider = Provider<Set<Marker>>(
  (ref) => ref.watch(taxiProvider.select((s) => s.markers)),
);

/// Initial camera position constant — used by TaxiMapView.
const kTaxiInitialCameraPosition = CameraPosition(
  target: _kInitialPosition,
  zoom: 14,
);

