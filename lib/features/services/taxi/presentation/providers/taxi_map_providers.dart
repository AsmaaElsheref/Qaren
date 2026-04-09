import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/utils/location_service.dart';
import 'taxi_constants.dart';
import 'taxi_notifier.dart';

// ── Granular selectors ────────────────────────────────────────────────────────

/// `true` only when pickup, destination, dates, and coordinates are all set.
final taxiCanCompareProvider = Provider<bool>(
  (ref) => ref.watch(
    taxiProvider.select(
      (s) =>
          s.pickup.isNotEmpty &&
          s.destination.isNotEmpty &&
          s.pickupLatLng != null &&
          s.destinationLatLng != null &&
          s.pickupDate != null &&
          s.returnDate != null,
    ),
  ),
);

/// `true` while the compare-prices async call is in flight.
final taxiIsLoadingProvider = Provider<bool>(
  (ref) => ref.watch(taxiProvider.select((s) => s.isLoading)),
);

/// `true` while a GPS / current-location fetch is in flight.
final taxiIsLocationLoadingProvider = Provider<bool>(
  (ref) => ref.watch(taxiProvider.select((s) => s.isLocationLoading)),
);

/// Derived markers set — rebuilds only when LatLng values change.
final taxiMarkersProvider = Provider<Set<Marker>>(
  (ref) => ref.watch(taxiProvider.select((s) => s.markers)),
);

// ── Initial map position ──────────────────────────────────────────────────────

/// Fetched once when the map opens.
/// Uses the real GPS position; falls back silently to Cairo if denied/unavailable.
final taxiInitialPositionProvider = FutureProvider<CameraPosition>((ref) async {
  final result = await LocationService.getCurrentLocation();
  final latLng = result.isSuccess ? result.position! : kInitialPosition;
  return CameraPosition(target: latLng, zoom: 15);
});

// ── Shared map state ──────────────────────────────────────────────────────────

/// Shared [GoogleMapController] — registered by [TaxiMapView] on map creation.
final taxiMapControllerProvider =
    StateProvider<GoogleMapController?>((ref) => null);

/// Current map camera centre — updated on every [onCameraMove].
/// Seeded from [taxiInitialPositionProvider] once it resolves.
final taxiCameraPositionProvider =
    StateProvider<LatLng>((ref) => kInitialPosition);

/// Toggles on every [onCameraIdle] — listened to by [MapPickerNotifier].
final taxiCameraIdleProvider = StateProvider<bool>((ref) => false);