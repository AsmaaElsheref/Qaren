import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qaren/core/localization/easy_localization.dart';

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
            title: pickupLabel.isNotEmpty
                ? pickupLabel
                : 'taxi.location.pickup'.tr(),
          ),
        ),
      if (destination != null)
        Marker(
          markerId: destinationMarkerId,
          position: destination,
          infoWindow: InfoWindow(
            title: destinationLabel.isNotEmpty
                ? destinationLabel
                : 'taxi.location.destination'.tr(),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
    };
  }
}
