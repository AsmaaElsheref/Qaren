import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Carries both the geographic coordinates and the human-readable address
/// name resolved after the user picks a location on the map or via GPS.
///
/// Used as the return value of [FoodMapPickerPage] so that callers never
/// have to reverse-geocode again.
class FoodLocationResult extends Equatable {
  const FoodLocationResult({
    required this.latLng,
    required this.name,
  });

  final LatLng latLng;

  /// Human-readable address resolved via reverse geocoding.
  /// Example: "شارع التحرير، وسط البلد، القاهرة"
  final String name;

  @override
  List<Object?> get props => [latLng, name];
}

