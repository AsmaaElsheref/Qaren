import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../domain/entities/route_entity.dart';
import '../../../domain/services/route_fee_calculatorr.dart';

class RouteState {
  final LatLng? pickupLocation;
  final LatLng? destinationLocation;
  final List<RouteEntity> routes;
  final String? selectedRouteId;
  final bool loadingRoutes;
  final String? errorMessage;

  const RouteState({
    this.pickupLocation,
    this.destinationLocation,
    this.routes = const [],
    this.selectedRouteId,
    this.loadingRoutes = false,
    this.errorMessage,
  });

  RouteEntity? get selectedRoute {
    final id = selectedRouteId;
    if (id == null) return null;
    for (final route in routes) {
      if (route.routeId == id) return route;
    }
    return null;
  }

  double? get distanceKm => selectedRoute?.distanceKm;
  int? get durationMinutes => selectedRoute?.durationMinutes;
  double? get deliveryFeeSar {
    final distance = distanceKm;
    if (distance == null) return null;
    return RouteFeeCalculator.calculate(distance);
  }

  bool get hasRoutes => routes.isNotEmpty;

  RouteState copyWith({
    LatLng? pickupLocation,
    LatLng? destinationLocation,
    List<RouteEntity>? routes,
    String? selectedRouteId,
    bool? loadingRoutes,
    String? errorMessage,
    bool clearPickup = false,
    bool clearDestination = false,
    bool clearSelectedRoute = false,
    bool clearError = false,
  }) {
    return RouteState(
      pickupLocation:
      clearPickup ? null : (pickupLocation ?? this.pickupLocation),
      destinationLocation: clearDestination
          ? null
          : (destinationLocation ?? this.destinationLocation),
      routes: routes ?? this.routes,
      selectedRouteId: clearSelectedRoute
          ? null
          : (selectedRouteId ?? this.selectedRouteId),
      loadingRoutes: loadingRoutes ?? this.loadingRoutes,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
