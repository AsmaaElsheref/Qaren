import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qaren/core/utils/polyline_decoder.dart';
import '../../../domain/entities/route_entity.dart';

class RouteModel extends RouteEntity {
  const RouteModel({
    required super.routeId,
    required super.encodedPolyline,
    required super.distanceKm,
    required super.durationMinutes,
    required super.points,
    required super.name,
    super.isSelected,
  });

  factory RouteModel.fromDirectionsJson(
    Map<String, dynamic> routeJson,
    int index,
  ) {
    final legs = routeJson['legs'] as List<dynamic>? ?? const [];
    final firstLeg = legs.isNotEmpty ? legs.first as Map<String, dynamic> : null;

    final distanceMeters =
        (firstLeg?['distance']?['value'] as num?)?.toDouble() ?? 0;
    final durationSeconds = (firstLeg?['duration']?['value'] as num?)?.toInt() ?? 0;
    final encodedPolyline =
        routeJson['overview_polyline']?['points'] as String? ?? '';
    final summary = routeJson['summary'] as String? ?? '';

    return RouteModel(
      routeId: 'route_$index',
      encodedPolyline: encodedPolyline,
      distanceKm: distanceMeters / 1000,
      durationMinutes: (durationSeconds / 60).ceil(),
      points: encodedPolyline.isEmpty
          ? const <LatLng>[]
          : PolylineDecoder.decode(encodedPolyline),
      name: summary.isEmpty ? 'مسار ${index + 1}' : summary,
    );
  }

  RouteEntity toEntity({bool isSelected = false}) {
    return RouteEntity(
      routeId: routeId,
      encodedPolyline: encodedPolyline,
      distanceKm: distanceKm,
      durationMinutes: durationMinutes,
      points: points,
      name: name,
      isSelected: isSelected,
    );
  }
}
