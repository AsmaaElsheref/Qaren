import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qaren/core/config/config.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/network/handelError/errors/failures.dart';
import '../models/route/route_model.dart';

abstract class DirectionsRemoteDataSource {
  Future<List<RouteModel>> getRoutes({
    required LatLng origin,
    required LatLng destination,
  });
}

class DirectionsRemoteDataSourceImpl implements DirectionsRemoteDataSource {
  const DirectionsRemoteDataSourceImpl({this.dio});

  final Dio? dio;

  @override
  Future<List<RouteModel>> getRoutes({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final apiKey = AppConfig.googleMapsApiKey;
    if (apiKey.isEmpty) {
      throw ServerFailure('taxi.directions.apiKeyMissing'.tr());
    }

    try {
      final client = dio ?? Dio();
      final response = await client.get<Map<String, dynamic>>(
        'https://maps.googleapis.com/maps/api/directions/json',
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'alternatives': 'true',
          'mode': 'driving',
          'key': apiKey,
        },
      );

      final body = response.data;
      if (body == null) {
        throw ServerFailure('taxi.directions.emptyResponse'.tr());
      }

      final status = body['status'] as String? ?? 'UNKNOWN_ERROR';
      if (status != 'OK') {
        throw ServerFailure(_messageForStatus(status));
      }

      final routesJson = body['routes'] as List<dynamic>? ?? const [];
      if (routesJson.isEmpty) {
        throw ServerFailure('taxi.directions.noRoutesAvailable'.tr());
      }

      return [
        for (var i = 0; i < routesJson.length; i++)
          RouteModel.fromDirectionsJson(
            routesJson[i] as Map<String, dynamic>,
            i,
          ),
      ];
    } on Failure {
      rethrow;
    } on DioException {
      throw NetworkFailure();
    }
  }

  static String _messageForStatus(String status) {
    switch (status) {
      case 'ZERO_RESULTS':
        return 'taxi.directions.zeroResults'.tr();
      case 'NOT_FOUND':
        return 'taxi.directions.notFound'.tr();
      case 'OVER_QUERY_LIMIT':
        return 'taxi.directions.overQueryLimit'.tr();
      case 'REQUEST_DENIED':
        return 'taxi.directions.requestDenied'.tr();
      default:
        return 'taxi.directions.loadFailedGeneric'.tr();
    }
  }
}
