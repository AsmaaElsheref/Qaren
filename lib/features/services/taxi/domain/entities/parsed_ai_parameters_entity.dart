import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Subset of the `ai_assistant.parsed_parameters` block returned by
/// `POST /api/compare/car-rental/ai-search`. Used as a fallback when the user
/// did not pre-fill pickup/destination on the map.
class ParsedAiParametersEntity extends Equatable {
  final double? pickupLat;
  final double? pickupLng;
  final double? dropoffLat;
  final double? dropoffLng;
  final String? destinationName;

  const ParsedAiParametersEntity({
    this.pickupLat,
    this.pickupLng,
    this.dropoffLat,
    this.dropoffLng,
    this.destinationName,
  });

  LatLng? get pickup =>
      (pickupLat != null && pickupLng != null) ? LatLng(pickupLat!, pickupLng!) : null;

  LatLng? get dropoff =>
      (dropoffLat != null && dropoffLng != null) ? LatLng(dropoffLat!, dropoffLng!) : null;

  @override
  List<Object?> get props =>
      [pickupLat, pickupLng, dropoffLat, dropoffLng, destinationName];
}

