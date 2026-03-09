import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/taxi_providers.dart';

class TaxiMapView extends ConsumerStatefulWidget {
  const TaxiMapView({super.key});

  @override
  ConsumerState<TaxiMapView> createState() => _TaxiMapViewState();
}

class _TaxiMapViewState extends ConsumerState<TaxiMapView> {
  GoogleMapController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = ref.watch(taxiMarkersProvider);

    return GoogleMap(
      initialCameraPosition: kTaxiInitialCameraPosition,
      markers: markers,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      onMapCreated: (controller) => _controller = controller,
      onTap: (latLng) {
        // Future: reverse-geocode & fill pickup or destination
      },
    );
  }
}
