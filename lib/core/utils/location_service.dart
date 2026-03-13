import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Result wrapper — either a [LatLng] or a human-readable [error] string.
class LocationResult {
  final LatLng? position;
  final String? error;

  const LocationResult.success(this.position) : error = null;
  const LocationResult.failure(this.error) : position = null;

  bool get isSuccess => position != null;
}

/// Stateless service — only static helpers.
/// All platform calls are here; nothing else in the app imports [Geolocator] directly.
class LocationService {
  LocationService._();

  /// Requests permission if needed, then returns the current [LatLng].
  /// Returns a [LocationResult.failure] with an Arabic message on any error.
  static Future<LocationResult> getCurrentLocation() async {
    // 1. Check if location services are enabled on the device.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const LocationResult.failure(
        'خدمة الموقع معطّلة، يرجى تفعيلها من الإعدادات',
      );
    }

    // 2. Check / request permission.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const LocationResult.failure(
          'تم رفض إذن الموقع',
        );
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return const LocationResult.failure(
        'إذن الموقع محظور دائمًا، يرجى تفعيله من إعدادات التطبيق',
      );
    }

    // 3. Fetch position.
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return LocationResult.success(LatLng(pos.latitude, pos.longitude));
    } catch (_) {
      return const LocationResult.failure('تعذّر تحديد موقعك الحالي');
    }
  }
}

