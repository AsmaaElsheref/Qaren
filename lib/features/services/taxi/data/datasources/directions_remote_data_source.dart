import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qaren/core/config/config.dart';
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
      throw const ServerFailure('مفتاح خرائط Google غير متوفر');
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
        throw const ServerFailure('استجابة فارغة من خدمة المسارات');
      }

      final status = body['status'] as String? ?? 'UNKNOWN_ERROR';
      if (status != 'OK') {
        throw ServerFailure(_messageForStatus(status));
      }

      final routesJson = body['routes'] as List<dynamic>? ?? const [];
      if (routesJson.isEmpty) {
        throw const ServerFailure('لا توجد مسارات متاحة بين هذين الموقعين');
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
      throw const NetworkFailure();
    }
  }

  static String _messageForStatus(String status) {
    switch (status) {
      case 'ZERO_RESULTS':
        return 'لا توجد مسارات بين هذين الموقعين';
      case 'NOT_FOUND':
        return 'تعذر العثور على أحد المواقع';
      case 'OVER_QUERY_LIMIT':
        return 'تم تجاوز حد طلبات المسارات';
      case 'REQUEST_DENIED':
        return 'تم رفض طلب المسارات';
      default:
        return 'تعذر تحميل المسارات';
    }
  }
}
