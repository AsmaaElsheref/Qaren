import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Reverse-geocodes a [LatLng] to a human-readable address.
/// Returns null on any failure or when no placemark is found.
class ReverseGeocoder {
  ReverseGeocoder._();

  static Future<String?> resolve(LatLng latLng) async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isEmpty) return null;
      final p = placemarks.first;
      final parts = [p.street, p.subLocality, p.locality, p.country]
          .where((s) => s != null && s.trim().isNotEmpty)
          .toList();
      if (parts.isEmpty) return null;
      return parts.join('، ');
    } catch (_) {
      return null;
    }
  }
}

