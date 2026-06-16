import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/features/services/taxi/domain/entities/route_entity.dart';

class MapPolylineBuilder {
  const MapPolylineBuilder._();

  static const routePolylineId = PolylineId('route_polyline_fallback');

  static Set<Polyline> buildRoutePolylines({
    required List<RouteEntity> routes,
    required String? selectedRouteId,
    required ValueChanged<String> onRouteTap,
  }) {
    if (routes.isEmpty) return const <Polyline>{};

    return {
      for (final route in routes)
        _buildPolyline(
          route: route,
          isSelected: route.routeId == selectedRouteId,
          onRouteTap: onRouteTap,
        ),
    };
  }

  static Polyline _buildPolyline({
    required RouteEntity route,
    required bool isSelected,
    required ValueChanged<String> onRouteTap,
  }) {
    return Polyline(
      polylineId: PolylineId(route.routeId),
      points: route.points,
      color: isSelected
          ? AppColors.primary
          : AppColors.textSecondary.withValues(alpha: 0.45),
      width: isSelected ? 8 : 4,
      zIndex: isSelected ? 2 : 1,
      geodesic: true,
      consumeTapEvents: true,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
      onTap: () => onRouteTap(route.routeId),
    );
  }

  static Set<Polyline> buildFallbackPolyline({
    required LatLng? pickup,
    required LatLng? destination,
  }) {
    if (pickup == null || destination == null) return const <Polyline>{};

    return {
      Polyline(
        polylineId: routePolylineId,
        points: [pickup, destination],
        color: AppColors.secondary.withValues(alpha: 0.7),
        width: 5,
        geodesic: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      ),
    };
  }
}
