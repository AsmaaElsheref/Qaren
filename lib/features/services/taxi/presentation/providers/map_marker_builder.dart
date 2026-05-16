import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Builds all taxi map markers from the selected pickup/destination state.
class MapMarkerBuilder {
  const MapMarkerBuilder._();

  static const pickupMarkerId = MarkerId('pickup_marker');
  static const destinationMarkerId = MarkerId('destination_marker');

  static Set<Marker> buildMarkers({
    required LatLng? pickup,
    required LatLng? destination,
    required String pickupLabel,
    required String destinationLabel,
  }) {
    return {
      if (pickup != null)
        Marker(
          markerId: pickupMarkerId,
          position: pickup,
          infoWindow: InfoWindow(
            title: pickupLabel.isNotEmpty ? pickupLabel : 'نقطة الانطلاق',
          ),
        ),
      if (destination != null)
        Marker(
          markerId: destinationMarkerId,
          position: destination,
          infoWindow: InfoWindow(
            title: destinationLabel.isNotEmpty ? destinationLabel : 'الوجهة',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
        ),
    };
  }
}

