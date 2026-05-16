import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Builds the taxi route polyline.
///
/// The current implementation uses a straight-line fallback. The async
/// [resolveRoutePoints] hook keeps this ready for Google Directions API
/// integration later without changing the UI/provider contract.
class MapPolylineBuilder {
  const MapPolylineBuilder._();

  static const routePolylineId = PolylineId('route_polyline');

  static Set<Polyline> buildRoutePolyline({
    required LatLng? pickup,
    required LatLng? destination,
    List<LatLng>? routePoints,
  }) {
    if (pickup == null || destination == null) return const <Polyline>{};

    final points = routePoints == null || routePoints.length < 2
        ? <LatLng>[pickup, destination]
        : routePoints;

    return {
      Polyline(
        polylineId: routePolylineId,
        points: points,
        color: Colors.blue,
        width: 6,
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      ),
    };
  }

  static Future<List<LatLng>?> resolveRoutePoints({
    required LatLng pickup,
    required LatLng destination,
  }) async {
    // TODO: Integrate Google Directions API here when an API key/service is
    // available, then return decoded overview polyline points. Returning null
    // intentionally falls back to the straight blue polyline above.
    return null;
  }
}

