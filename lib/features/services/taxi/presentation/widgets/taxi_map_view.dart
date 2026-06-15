import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qaren/features/profile/presentation/providers/profileSettings/profile_settings_provider.dart';
import '../providers/taxi_providers.dart';

const _darkMapStyle =
    '[{"elementType":"geometry","stylers":[{"color":"#212121"}]},'
    '{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},'
    '{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},'
    '{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},'
    '{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},'
    '{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},'
    '{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},'
    '{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},'
    '{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},'
    '{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},'
    '{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},'
    '{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},'
    '{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},'
    '{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},'
    '{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},'
    '{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},'
    '{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},'
    '{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},'
    '{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},'
    '{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},'
    '{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]';

/// The single GoogleMap instance for the whole taxi flow.
/// Starts the camera at the user's real GPS position (falls back to Cairo).
class TaxiMapView extends ConsumerStatefulWidget {
  const TaxiMapView({super.key, this.isPicker});
  final bool? isPicker;

  @override
  ConsumerState<TaxiMapView> createState() => _TaxiMapViewState();
}

class _TaxiMapViewState extends ConsumerState<TaxiMapView> {
  GoogleMapController? _controller;
  TaxiMapControllerNotifier? _controllerNotifier;
  bool _didAnimateInitial = false;

  // ── Padding ───────────────────────────────────────────────────────────────
  /// Bottom padding so the LocationSheet never covers markers/polyline.
  static const double _boundsPadding = 160.0;
  static const double _pickupZoom = 15.5;
  static const double _singleZoom = 15.0;

  @override
  void dispose() {
    final controller = _controller;
    if (controller != null) {
      _controllerNotifier?.detachAfterDispose(controller);
      controller.dispose();
    }
    _controller = null;
    _controllerNotifier = null;
    super.dispose();
  }

  // ── Initial GPS animation ─────────────────────────────────────────────────
  /// Called once after the map is created and the GPS future resolves.
  /// Must NOT be called again when markers/polyline providers rebuild.
  void _animateToInitial(CameraPosition pos) {
    if (_didAnimateInitial) return;
    _didAnimateInitial = true;
    _controllerNotifier?.animateToInitial(pos);
    ref.read(taxiCameraPositionProvider.notifier).state = pos.target;
  }

  // ── Camera helpers (side effects, never rebuild the widget) ───────────────

  /// Animate to a single location (pickup only or destination only).
  Future<void> _animateToSingleLocation(LatLng target, double zoom) async {
    final controller = _controller;
    if (controller == null || !mounted) return;
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(target, zoom),
    );
  }

  /// Fit both pickup and destination inside the viewport with proper padding.
  Future<void> _fitPickupAndDestination(
    LatLng pickup,
    LatLng destination,
  ) async {
    final controller = _controller;
    if (controller == null || !mounted) return;

    // Same point – just zoom in.
    if (pickup.latitude == destination.latitude &&
        pickup.longitude == destination.longitude) {
      await _animateToSingleLocation(pickup, _singleZoom);
      return;
    }

    final bounds = LatLngBounds(
      southwest: LatLng(
        math.min(pickup.latitude, destination.latitude),
        math.min(pickup.longitude, destination.longitude),
      ),
      northeast: LatLng(
        math.max(pickup.latitude, destination.latitude),
        math.max(pickup.longitude, destination.longitude),
      ),
    );

    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, _boundsPadding),
    );
  }

  /// Called by both listeners; decides which camera action is appropriate.
  Future<void> _handleLocationChange({
    required LatLng? pickup,
    required LatLng? destination,
  }) async {
    if (!mounted || _controller == null) return;

    if (pickup != null && destination != null) {
      await _fitPickupAndDestination(pickup, destination);
      return;
    }

    if (pickup != null) {
      await _animateToSingleLocation(pickup, _pickupZoom);
      return;
    }

    if (destination != null) {
      await _animateToSingleLocation(destination, _singleZoom);
    }
  }

  void _applyMapStyle(bool isDarkMode) {
    _controller?.setMapStyle(isDarkMode ? _darkMapStyle : null);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(profileIsDarkModeProvider);

    ref.listen<bool>(profileIsDarkModeProvider, (prev, next) {
      if (prev == next) return;
      _applyMapStyle(next);
    });

    // ── Pickup listener – camera side effect only, no rebuild ─────────────
    ref.listen<LatLng?>(taxiPickupLocationProvider, (prev, next) {
      if (next == null) return;
      if (prev?.latitude == next.latitude &&
          prev?.longitude == next.longitude) return;
      _handleLocationChange(
        pickup: next,
        destination: ref.read(taxiDestinationLocationProvider),
      );
    });

    // ── Destination listener – camera side effect only, no rebuild ─────────
    ref.listen<LatLng?>(taxiDestinationLocationProvider, (prev, next) {
      if (next == null) return;
      if (prev?.latitude == next.latitude &&
          prev?.longitude == next.longitude) return;
      _handleLocationChange(
        pickup: ref.read(taxiPickupLocationProvider),
        destination: next,
      );
    });

    // ── Map overlays (markers + polyline) ─────────────────────────────────
    final markers = ref.watch(taxiMarkersProvider);
    final polylines = ref.watch(taxiRoutePolylineProvider);

    // ── Initial camera position ───────────────────────────────────────────
    final initialAsync = ref.watch(taxiInitialPositionProvider);

    return initialAsync.when(
      loading: () => _buildMap(
        kTaxiInitialCameraPosition,
        markers,
        polylines,
        isDarkMode,
      ),
      error: (_, __) => _buildMap(
        kTaxiInitialCameraPosition,
        markers,
        polylines,
        isDarkMode,
      ),
      data: (realPos) {
        // Animate once only; marker/polyline rebuilds must not reset camera.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _controller != null) _animateToInitial(realPos);
        });
        return _buildMap(realPos, markers, polylines, isDarkMode);
      },
    );
  }

  Widget _buildMap(
    CameraPosition initialPos,
    Set<Marker> markers,
    Set<Polyline> polylines,
    bool isDarkMode,
  ) {
    return GoogleMap(
      initialCameraPosition: initialPos,
      style: isDarkMode ? _darkMapStyle : null,
      markers: markers,
      polylines: polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      onMapCreated: (controller) {
        _controller = controller;
        final notifier = ref.read(taxiMapControllerProvider.notifier);
        notifier.attach(controller);
        _controllerNotifier = notifier;
        _applyMapStyle(ref.read(profileIsDarkModeProvider));
        // Animate to GPS position if it already resolved before map was ready.
        final pos = ref.read(taxiInitialPositionProvider).valueOrNull;
        if (pos != null) _animateToInitial(pos);
      },
      onCameraMove: (pos) =>
          ref.read(taxiCameraPositionProvider.notifier).state = pos.target,
      onCameraIdle: () =>
          ref.read(taxiCameraIdleProvider.notifier).update((v) => !v),
    );
  }
}
