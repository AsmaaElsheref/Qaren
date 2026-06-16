import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteEntity extends Equatable {
  final String routeId;
  final String encodedPolyline;
  final double distanceKm;
  final int durationMinutes;
  final List<LatLng> points;
  final String name;
  final bool isSelected;

  const RouteEntity({
    required this.routeId,
    required this.encodedPolyline,
    required this.distanceKm,
    required this.durationMinutes,
    required this.points,
    required this.name,
    this.isSelected = false,
  });

  RouteEntity copyWith({
    bool? isSelected,
  }) {
    return RouteEntity(
      routeId: routeId,
      encodedPolyline: encodedPolyline,
      distanceKm: distanceKm,
      durationMinutes: durationMinutes,
      points: points,
      name: name,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [routeId, distanceKm, durationMinutes, isSelected];
}
