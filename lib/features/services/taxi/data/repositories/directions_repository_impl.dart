import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/network/handelError/errors/failures.dart';
import '../../../../../core/utils/either.dart';
import '../../domain/entities/route_entity.dart';
import '../../domain/repositories/directions_repositoryy.dart';
import '../datasources/directions_remote_data_source.dart';

class DirectionsRepositoryImpl implements DirectionsRepository {
  const DirectionsRepositoryImpl(this._remoteDataSource);

  final DirectionsRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<RouteEntity>>> getRoutes({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final models = await _remoteDataSource.getRoutes(
        origin: origin,
        destination: destination,
      );
      return Either.rightOf(models.map((m) => m.toEntity()).toList());
    } on Failure catch (failure) {
      return Either.leftOf(failure);
    } catch (_) {
      return Either.leftOf(
        const ServerFailure('فشل تحميل المسارات. حاول مرة أخرى.'),
      );
    }
  }
}
