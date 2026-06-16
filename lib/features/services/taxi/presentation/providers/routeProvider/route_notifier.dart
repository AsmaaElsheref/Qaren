import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/datasources/directions_remote_datasource.dart';
import '../../../data/repositories/directions_repository_impl.dart';
import '../../../domain/entities/route_entity.dart';
import '../../../domain/repositories/directions_repository.dart';
import '../../../domain/usecases/get_routes_usecase.dart';
import 'route_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Dependencies
// ─────────────────────────────────────────────────────────────────────────────

final _directionsDataSourceProvider =
    Provider<DirectionsRemoteDataSource>((ref) {
  return const DirectionsRemoteDataSourceImpl();
});

final _directionsRepositoryProvider =
    Provider<DirectionsRepository>((ref) {
  final DirectionsRemoteDataSource dataSource = ref.watch(
    _directionsDataSourceProvider,
  );

  return DirectionsRepositoryImpl(dataSource);
});

final _getRoutesUseCaseProvider = Provider<GetRoutesUseCase>((ref) {
  final DirectionsRepository repository = ref.watch(
    _directionsRepositoryProvider,
  );

  return GetRoutesUseCase(repository);
});

// ─────────────────────────────────────────────────────────────────────────────
// Route notifier
// ─────────────────────────────────────────────────────────────────────────────

class RouteNotifier extends Notifier<RouteState> {
  @override
  RouteState build() {
    return const RouteState();
  }

  void reset() {
    state = const RouteState();
  }

  void clearRoutes() {
    state = state.copyWith(
      routes: const <RouteEntity>[],
      clearSelectedRoute: true,
      loadingRoutes: false,
      clearError: true,
    );
  }

  void setPickupLocation(LatLng location) {
    state = state.copyWith(
      pickupLocation: location,
      clearError: true,
    );
  }

  void setDestinationLocation(LatLng location) {
    state = state.copyWith(
      destinationLocation: location,
      clearError: true,
    );
  }

  Future<void> loadRoutes({
    required LatLng origin,
    required LatLng destination,
  }) async {
    state = state.copyWith(
      pickupLocation: origin,
      destinationLocation: destination,
      loadingRoutes: true,
      routes: const <RouteEntity>[],
      clearSelectedRoute: true,
      clearError: true,
    );

    try {
      final GetRoutesUseCase getRoutesUseCase = ref.read(
        _getRoutesUseCaseProvider,
      );

      final result = await getRoutesUseCase.call(
        origin: origin,
        destination: destination,
      );

      result.fold<void>(
        (failure) {
          state = state.copyWith(
            loadingRoutes: false,
            errorMessage: failure.message,
          );
        },
        (List<RouteEntity> routes) {
          if (routes.isEmpty) {
            state = state.copyWith(
              loadingRoutes: false,
              routes: const <RouteEntity>[],
              clearSelectedRoute: true,
              errorMessage: 'لا توجد مسارات متاحة',
            );
            return;
          }

          final String selectedRouteId = _pickDefaultRouteId(routes);

          state = state.copyWith(
            loadingRoutes: false,
            routes: routes,
            selectedRouteId: selectedRouteId,
            clearError: true,
          );
        },
      );
    } catch (error) {
      state = state.copyWith(
        loadingRoutes: false,
        errorMessage: error.toString(),
      );
    }
  }

  void selectRoute(String routeId) {
    if (state.selectedRouteId == routeId) {
      return;
    }

    final bool routeExists = state.routes.any(
      (RouteEntity route) => route.routeId == routeId,
    );

    if (!routeExists) {
      return;
    }

    state = state.copyWith(
      selectedRouteId: routeId,
      clearError: true,
    );
  }

  String _pickDefaultRouteId(List<RouteEntity> routes) {
    RouteEntity bestRoute = routes.first;

    for (final RouteEntity route in routes.skip(1)) {
      if (route.durationMinutes < bestRoute.durationMinutes) {
        bestRoute = route;
      }
    }

    return bestRoute.routeId;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main provider
// ─────────────────────────────────────────────────────────────────────────────

final routeProvider = NotifierProvider<RouteNotifier, RouteState>(
  RouteNotifier.new,
);

// ─────────────────────────────────────────────────────────────────────────────
// Selectors
// ─────────────────────────────────────────────────────────────────────────────

final routeSelectedDistanceProvider = Provider<double?>((ref) {
  return ref.watch(
    routeProvider.select(
      (RouteState state) => state.distanceKm,
    ),
  );
});

final routeSelectedDurationProvider = Provider<int?>((ref) {
  return ref.watch(
    routeProvider.select(
      (RouteState state) => state.durationMinutes,
    ),
  );
});

final routeDeliveryFeeProvider = Provider<double?>((ref) {
  return ref.watch(
    routeProvider.select(
      (RouteState state) => state.deliveryFeeSar,
    ),
  );
});

final routeSelectedNameProvider = Provider<String?>((ref) {
  return ref.watch(
    routeProvider.select(
      (RouteState state) => state.selectedRoute?.name,
    ),
  );
});

final routeLoadingProvider = Provider<bool>((ref) {
  return ref.watch(
    routeProvider.select(
      (RouteState state) => state.loadingRoutes,
    ),
  );
});

final routeHasRoutesProvider = Provider<bool>((ref) {
  return ref.watch(
    routeProvider.select(
      (RouteState state) => state.hasRoutes,
    ),
  );
});