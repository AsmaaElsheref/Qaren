import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocationData {
  final LatLng? currentLocation;
  final String? locationName;

  CurrentLocationData({
    this.currentLocation,
    this.locationName,
  });
}