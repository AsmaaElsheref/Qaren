import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/taxi_providers.dart';

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

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  /// Called once the controller is ready AND the GPS future resolved.
  /// Animates to the real position and seeds [taxiCameraPositionProvider].
  void _animateToInitial(CameraPosition pos) {
    _controller?.animateCamera(CameraUpdate.newCameraPosition(pos));
    ref.read(taxiCameraPositionProvider.notifier).state = pos.target;
  }

  @override
  Widget build(BuildContext context) {
    final markers = widget.isPicker!=null? const <Marker>{} : ref.watch(taxiMarkersProvider);

    // Watch the initial-position future.
    final initialAsync = ref.watch(taxiInitialPositionProvider);

    return initialAsync.when(
      // While GPS is resolving, show the map at the Cairo fallback so it
      // renders immediately — then we animate once the future completes.
      loading: () => _buildMap(kTaxiInitialCameraPosition, markers),
      error: (_, __) => _buildMap(kTaxiInitialCameraPosition, markers),
      data: (realPos) {
        // Animate if the controller is already attached (page was warm).
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_controller != null) _animateToInitial(realPos);
        });
        return _buildMap(realPos, markers);
      },
    );
  }

  Widget _buildMap(CameraPosition initialPos, Set<Marker> markers) {
    return GoogleMap(
      initialCameraPosition: initialPos,
      markers: widget.isPicker==null?markers:{},
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      onMapCreated: (controller) {
        _controller = controller;
        ref.read(taxiMapControllerProvider.notifier).state = controller;
        // Animate to the resolved GPS position if already available.
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
