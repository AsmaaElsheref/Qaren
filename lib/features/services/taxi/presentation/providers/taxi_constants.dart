import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Default map camera — Cairo, Egypt.
/// Single source of truth — imported by both taxi and map-picker layers.
const kInitialPosition = LatLng(30.0444, 31.2357);

const kTaxiInitialCameraPosition = CameraPosition(
  target: kInitialPosition,
  zoom: 14,
);

