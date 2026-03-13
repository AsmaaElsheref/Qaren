import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_picker_state.dart';
import 'taxi_map_providers.dart';
import 'taxi_notifier.dart';
import 'taxi_state.dart';


class MapPickerNotifier extends AutoDisposeFamilyNotifier<MapPickerState, TaxiActiveField> {
  Timer? _debounce;
  bool _disposed = false;

  final searchController = TextEditingController();

  @override
  MapPickerState build(TaxiActiveField arg) {
    // Start at the already-confirmed position for this field, or map centre.
    final taxiState = ref.read(taxiProvider);
    final LatLng initial = (arg == TaxiActiveField.pickup
            ? taxiState.pickupLatLng
            : taxiState.destinationLatLng) ??
        ref.read(taxiCameraPositionProvider);

    // Animate the shared map to the saved position.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_disposed) return;
      ref
          .read(taxiMapControllerProvider)
          ?.animateCamera(CameraUpdate.newLatLngZoom(initial, 15));
      _resolveAddress(initial);
    });

    // React every time the camera finishes moving.
    ref.listen<bool>(taxiCameraIdleProvider, (_, __) {
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

  // ── Reverse geocode ───────────────────────────────────────────────────────

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
          addressLabel:
              parts.isNotEmpty ? parts.join('، ') : 'موقع غير معروف',
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

  // ── Forward geocode (search bar) ──────────────────────────────────────────

  Future<void> searchAddress() async {
    final query = searchController.text.trim();
    if (query.isEmpty) return;
    try {
      final locations = await geo.locationFromAddress(query);
      if (_disposed || locations.isEmpty) return;
      final target =
          LatLng(locations.first.latitude, locations.first.longitude);
      ref
          .read(taxiMapControllerProvider)
          ?.animateCamera(CameraUpdate.newLatLngZoom(target, 16));
      // onCameraIdle → debounce → _resolveAddress fires automatically
    } catch (_) {}
  }

  // ── Confirm selected location ─────────────────────────────────────────────

  Future<void> confirm() async {
    state = state.copyWith(isConfirming: true);
    ref.read(taxiProvider.notifier).confirmLocation(
          field: arg,
          latLng: state.center,
          label: state.addressLabel,
        );
    state = state.copyWith(isConfirming: false);
  }
}

