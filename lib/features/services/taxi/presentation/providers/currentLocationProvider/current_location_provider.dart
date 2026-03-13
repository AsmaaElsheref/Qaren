import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../../core/utils/location_service.dart';
import 'current_location_state.dart';

class CurrentLocationProvider extends AsyncNotifier<CurrentLocationData>{

  @override
  Future<CurrentLocationData> build() async {
    await getCurrentLocation();
    return CurrentLocationData(currentLocation: latLng,locationName: myLocationName);
  }

  /// GET CURRENT LOCATION
  String? myLocationName;
  LatLng? latLng;
  getCurrentLocation() async {
    try {
      final result = await LocationService.getCurrentLocation();
      if (!result.isSuccess) {
        return result.error;
      }
      latLng = result.position!;
        final placemarks = await geo.placemarkFromCoordinates(
          latLng!.latitude,
          latLng!.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = [p.street, p.subLocality, p.locality]
              .where((s) => s != null && s.isNotEmpty)
              .toList();
          if (parts.isNotEmpty) myLocationName = parts.join('، ');
        }
        state  = AsyncData(CurrentLocationData(
          currentLocation: result.position!,
          locationName: myLocationName,
        ));
      return null;
    }catch(e){
      debugPrint('Error getting current location: $e');
    }
  }
}

final currentLocationProvider = AsyncNotifierProvider<CurrentLocationProvider, CurrentLocationData>(() => CurrentLocationProvider(),);