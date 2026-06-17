import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/network/handelError/errors/failures.dart';
import '../../../../../core/utils/either.dart';
import '../entities/route_entity.dart';
import '../repositories/directions_repositoryy.dart';

class GetRoutesUseCase {
  const GetRoutesUseCase(this._repository);

  final DirectionsRepository _repository;

  Future<Either<Failure, List<RouteEntity>>> call({
    required LatLng origin,
    required LatLng destination,
  }) {
    return _repository.getRoutes(origin: origin, destination: destination);
  }
}
