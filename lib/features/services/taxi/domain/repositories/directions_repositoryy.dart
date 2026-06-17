import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/network/handelError/errors/failures.dart';
import '../../../../../core/utils/either.dart';
import '../entities/route_entity.dart';

abstract class DirectionsRepository {
  Future<Either<Failure, List<RouteEntity>>> getRoutes({
    required LatLng origin,
    required LatLng destination,
  });
}
