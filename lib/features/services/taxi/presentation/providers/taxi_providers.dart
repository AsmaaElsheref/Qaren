import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ── Which field is currently being edited ────────────────────────────────────
enum TaxiActiveField { pickup, destination }

// ── State ────────────────────────────────────────────────────────────────────

/// Default camera — Cairo, Egypt
const kInitialPosition = LatLng(30.0444, 31.2357);

// keep old private alias for internal use
const _kInitialPosition = kInitialPosition;

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

/// Shared [GoogleMapController] — registered by [TaxiMapView] on map creation.
final taxiMapControllerProvider =
    StateProvider<GoogleMapController?>((ref) => null);

/// Current map camera center — updated on every [onCameraMove].
final taxiCameraPositionProvider =
    StateProvider<LatLng>((ref) => _kInitialPosition);

/// Toggles (true↔false) on every [onCameraIdle] — triggers geocoding.
final taxiCameraIdleProvider = StateProvider<bool>((ref) => false);

/// True while [MapPickerPage] is on screen.
final taxiMapPickerActiveProvider = StateProvider<bool>((ref) => false);

/// Initial camera position constant — used by TaxiMapView.
const kTaxiInitialCameraPosition = CameraPosition(
  target: _kInitialPosition,
  zoom: 14,
);

// ── Map Picker ────────────────────────────────────────────────────────────────

class MapPickerState {
  final LatLng center;
  final String addressLabel;
  final bool isResolving;
  final bool isConfirming;

  const MapPickerState({
    required this.center,
    this.addressLabel = 'جاري تحديد الموقع...',
    this.isResolving = true,
    this.isConfirming = false,
  });

  MapPickerState copyWith({
    LatLng? center,
    String? addressLabel,
    bool? isResolving,
    bool? isConfirming,
  }) =>
      MapPickerState(
        center: center ?? this.center,
        addressLabel: addressLabel ?? this.addressLabel,
        isResolving: isResolving ?? this.isResolving,
        isConfirming: isConfirming ?? this.isConfirming,
      );
}

class MapPickerNotifier
    extends AutoDisposeFamilyNotifier<MapPickerState, TaxiActiveField> {
  Timer? _debounce;
  bool _disposed = false;

  /// The TextEditingController for the search field.
  /// Owned here so the UI never needs to manage it.
  final searchController = TextEditingController();

  @override
  MapPickerState build(TaxiActiveField arg) {
    // Start at the already-confirmed position for this field, or map center.
    final taxiState = ref.read(taxiProvider);
    final LatLng initial = (arg == TaxiActiveField.pickup
            ? taxiState.pickupLatLng
            : taxiState.destinationLatLng) ??
        ref.read(taxiCameraPositionProvider);

    // Animate the shared map to the initial position.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = ref.read(taxiMapControllerProvider);
      if (controller != null) {
        controller.animateCamera(CameraUpdate.newLatLngZoom(initial, 15));
      }
      _resolveAddress(initial);
    });

    // Listen to camera-idle — triggered by TaxiMapView.onCameraIdle.
    ref.listen(taxiCameraIdleProvider, (_, __) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 600), () {
        _resolveAddress(ref.read(taxiCameraPositionProvider));
      });
    });

    ref.onDispose(() {
      _disposed = true;
      _debounce?.cancel();
      searchController.dispose();
    });

    return MapPickerState(center: initial);
  }

  // ── Reverse geocode ─────────────────────────────────────────────────────
  Future<void> _resolveAddress(LatLng pos) async {
    if (_disposed) return;
    state = state.copyWith(center: pos, isResolving: true);
    try {
      final placemarks =
          await geo.placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (_disposed) return;
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [p.street, p.subLocality, p.locality]
            .where((s) => s != null && s.isNotEmpty)
            .toList();
        state = state.copyWith(
          addressLabel: parts.isNotEmpty ? parts.join('، ') : 'موقع غير معروف',
          isResolving: false,
        );
      }
    } catch (_) {
      if (!_disposed) {
        state = state.copyWith(
          addressLabel: 'تعذّر تحديد الموقع',
          isResolving: false,
        );
      }
    }
  }

  // ── Forward geocode (search bar) ────────────────────────────────────────
  Future<void> searchAddress() async {
    final query = searchController.text.trim();
    if (query.isEmpty) return;
    try {
      final locations = await geo.locationFromAddress(query);
      if (_disposed || locations.isEmpty) return;
      final loc = locations.first;
      final target = LatLng(loc.latitude, loc.longitude);
      ref.read(taxiMapControllerProvider)?.animateCamera(
            CameraUpdate.newLatLngZoom(target, 16),
          );
      // onCameraIdle → debounce → _resolveAddress will fire automatically
    } catch (_) {}
  }

  // ── Confirm selected location ───────────────────────────────────────────
  void confirm() {
    state = state.copyWith(isConfirming: true);
    ref.read(taxiProvider.notifier).confirmLocation(
          field: arg,
          latLng: state.center,
          label: state.addressLabel,
        );
    ref.read(taxiMapPickerActiveProvider.notifier).state = false;
  }
}

/// Family provider — one instance per [TaxiActiveField], auto-disposed on pop.
final mapPickerProvider = NotifierProvider.autoDispose
    .family<MapPickerNotifier, MapPickerState, TaxiActiveField>(
  MapPickerNotifier.new,
);
