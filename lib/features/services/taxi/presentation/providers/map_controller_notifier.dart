import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Owns the shared GoogleMapController and all taxi camera animations.
class TaxiMapControllerNotifier extends Notifier<GoogleMapController?> {
  static const double _pickupZoom = 15.5;
  static const double _singlePointZoom = 15.0;
  static const double _maxRouteZoom = 15.5;
  static const double _boundsPadding = 110.0;

  @override
  GoogleMapController? build() => null;

  void attach(GoogleMapController controller) {
    state = controller;
  }

  void detach(GoogleMapController controller) {
    if (identical(state, controller)) state = null;
  }

  Future<void> animateForLocations({
    required LatLng? pickup,
    required LatLng? destination,
  }) async {
    final controller = state;
    if (controller == null) return;

    if (pickup != null && destination != null) {
      await _fitPickupAndDestination(controller, pickup, destination);
      return;
    }

    if (pickup != null) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(pickup, _pickupZoom),
      );
      return;
    }

    if (destination != null) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(destination, _singlePointZoom),
      );
    }
  }

  Future<void> animateToInitial(CameraPosition position) async {
    final controller = state;
    if (controller == null) return;
    await controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  Future<void> _fitPickupAndDestination(
    GoogleMapController controller,
    LatLng pickup,
    LatLng destination,
  ) async {
    if (_isSamePoint(pickup, destination)) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(pickup, _singlePointZoom),
      );
      return;
    }

    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        _boundsFrom(pickup, destination),
        _boundsPadding,
      ),
    );

    final zoom = await controller.getZoomLevel();
    if (zoom > _maxRouteZoom) {
      await controller.animateCamera(CameraUpdate.zoomTo(_maxRouteZoom));
    }
  }

  LatLngBounds _boundsFrom(LatLng first, LatLng second) {
    final south = math.min(first.latitude, second.latitude);
    final north = math.max(first.latitude, second.latitude);
    final west = math.min(first.longitude, second.longitude);
    final east = math.max(first.longitude, second.longitude);

    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  bool _isSamePoint(LatLng first, LatLng second) {
    return first.latitude == second.latitude && first.longitude == second.longitude;
  }
}

final taxiMapControllerProvider =
    NotifierProvider<TaxiMapControllerNotifier, GoogleMapController?>(
  TaxiMapControllerNotifier.new,
);

