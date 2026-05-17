import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Owns the shared GoogleMapController and all taxi camera animations.
class TaxiMapControllerNotifier extends Notifier<GoogleMapController?> {
  static const double _pickupZoom = 15.5;
  static const double _destinationZoom = 15.0;
  static const double _singlePointZoom = 15.0;
  static const double _maxRouteZoom = 15.5;
  static const double _boundsPadding = 180.0;

  LatLng? _pendingPickup;
  LatLng? _pendingDestination;

  @override
  GoogleMapController? build() => null;

  void attach(GoogleMapController controller) {
    state = controller;
    final pickup = _pendingPickup;
    final destination = _pendingDestination;
    _pendingPickup = null;
    _pendingDestination = null;
    if (pickup != null || destination != null) {
      Future<void>(() => focusOnSelectedTaxiLocations(
            pickup: pickup,
            destination: destination,
          ));
    }
  }

  void detach(GoogleMapController controller) {
    if (identical(state, controller)) state = null;
  }

  void detachAfterDispose(GoogleMapController controller) {
    Future<void>(() {
      if (identical(state, controller)) state = null;
    });
  }

  Future<void> focusOnPickup(LatLng pickup) async {
    final controller = state;
    if (controller == null) {
      _pendingPickup = pickup;
      _pendingDestination = null;
      return;
    }

    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(pickup, _pickupZoom),
    );
  }

  Future<void> focusOnDestination(LatLng destination) async {
    final controller = state;
    if (controller == null) {
      _pendingPickup = null;
      _pendingDestination = destination;
      return;
    }

    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(destination, _destinationZoom),
    );
  }

  Future<void> fitPickupAndDestination(
    LatLng pickup,
    LatLng destination,
  ) async {
    final controller = state;
    if (controller == null) {
      _pendingPickup = pickup;
      _pendingDestination = destination;
      return;
    }

    await _fitPickupAndDestination(controller, pickup, destination);
  }

  Future<void> focusOnSelectedTaxiLocations({
    required LatLng? pickup,
    required LatLng? destination,
  }) async {
    if (pickup != null && destination != null) {
      await fitPickupAndDestination(pickup, destination);
      return;
    }

    if (pickup != null) {
      await focusOnPickup(pickup);
      return;
    }

    if (destination != null) {
      await focusOnDestination(destination);
    }
  }

  Future<void> animateForLocations({
    required LatLng? pickup,
    required LatLng? destination,
  }) =>
      focusOnSelectedTaxiLocations(
        pickup: pickup,
        destination: destination,
      );

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
    if (!identical(state, controller)) return;
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

    if (!identical(state, controller)) return;
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
