import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/utils/location_service.dart';
import 'map_marker_builder.dart';
import 'map_polyline_builder.dart';
import 'taxi_constants.dart';
import 'taxi_notifier.dart';

// ── Granular selectors ────────────────────────────────────────────────────────

final taxiPickupLocationProvider = Provider<LatLng?>(
  (ref) => ref.watch(taxiProvider.select((s) => s.pickupLatLng)),
);

final taxiDestinationLocationProvider = Provider<LatLng?>(
  (ref) => ref.watch(taxiProvider.select((s) => s.destinationLatLng)),
);

final taxiPickupLabelProvider = Provider<String>(
  (ref) => ref.watch(taxiProvider.select((s) => s.pickup)),
);

final taxiDestinationLabelProvider = Provider<String>(
  (ref) => ref.watch(taxiProvider.select((s) => s.destination)),
);

/// `true` when pickup and destination refer to the same place.
final taxiSameLocationProvider = Provider<bool>(
  (ref) => ref.watch(
    taxiProvider.select((s) {
      if (s.pickup.isEmpty || s.destination.isEmpty) return false;

      final sameText = s.pickup.trim() == s.destination.trim();
      if (s.pickupLatLng == null || s.destinationLatLng == null) {
        return sameText;
      }

      return sameText ||
          (s.pickupLatLng!.latitude == s.destinationLatLng!.latitude &&
              s.pickupLatLng!.longitude == s.destinationLatLng!.longitude);
    }),
  ),
);

/// `true` only when pickup, destination, and coordinates are all set.
final taxiCanCompareProvider = Provider<bool>(
  (ref) => ref.watch(
    taxiProvider.select(
      (s) =>
          s.pickup.isNotEmpty &&
          s.destination.isNotEmpty &&
          s.pickupLatLng != null &&
          s.destinationLatLng != null,
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

/// Derived markers set — rebuilds only when labels/LatLng values change.
final taxiMarkersProvider = Provider<Set<Marker>>(
  (ref) => MapMarkerBuilder.buildMarkers(
    pickup: ref.watch(taxiPickupLocationProvider),
    destination: ref.watch(taxiDestinationLocationProvider),
    pickupLabel: ref.watch(taxiPickupLabelProvider),
    destinationLabel: ref.watch(taxiDestinationLabelProvider),
  ),
);

/// Route polyline provider. Uses straight-line fallback until Directions API is wired.
final taxiRoutePolylineProvider = Provider<Set<Polyline>>(
  (ref) => MapPolylineBuilder.buildRoutePolyline(
    pickup: ref.watch(taxiPickupLocationProvider),
    destination: ref.watch(taxiDestinationLocationProvider),
  ),
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
/// The provider itself is declared in [map_controller_notifier.dart].

/// Current map camera centre — updated on every [onCameraMove].
/// Seeded from [taxiInitialPositionProvider] once it resolves.
final taxiCameraPositionProvider =
    StateProvider<LatLng>((ref) => kInitialPosition);

/// Toggles on every [onCameraIdle] — listened to by [MapPickerNotifier].
final taxiCameraIdleProvider = StateProvider<bool>((ref) => false);

