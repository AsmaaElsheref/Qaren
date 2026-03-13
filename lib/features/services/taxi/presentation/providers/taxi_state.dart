import 'package:google_maps_flutter/google_maps_flutter.dart';

enum TaxiActiveField { pickup, destination }

class TaxiState {
  final String pickup;
  final String destination;
  final bool isLoading;
  final bool isLocationLoading;
  final LatLng? pickupLatLng;
  final LatLng? destinationLatLng;

  const TaxiState({
    this.pickup = '',
    this.destination = '',
    this.isLoading = false,
    this.isLocationLoading = false,
    this.pickupLatLng,
    this.destinationLatLng,
  });

  TaxiState copyWith({
    String? pickup,
    String? destination,
    bool? isLoading,
    bool? isLocationLoading,
    LatLng? pickupLatLng,
    LatLng? destinationLatLng,
    bool clearPickupLatLng = false,
    bool clearDestinationLatLng = false,
  }) =>
      TaxiState(
        pickup: pickup ?? this.pickup,
        destination: destination ?? this.destination,
        isLoading: isLoading ?? this.isLoading,
        isLocationLoading: isLocationLoading ?? this.isLocationLoading,
        pickupLatLng:
            clearPickupLatLng ? null : (pickupLatLng ?? this.pickupLatLng),
        destinationLatLng: clearDestinationLatLng
            ? null
            : (destinationLatLng ?? this.destinationLatLng),
      );

  Set<Marker> get markers => {
        if (pickupLatLng != null)
          Marker(
            markerId: const MarkerId('pickup'),
            position: pickupLatLng!,
            infoWindow: InfoWindow(
              title: pickup.isNotEmpty ? pickup : 'نقطة الانطلاق',
            ),
          ),
        if (destinationLatLng != null)
          Marker(
            markerId: const MarkerId('destination'),
            position: destinationLatLng!,
            infoWindow: InfoWindow(
              title: destination.isNotEmpty ? destination : 'الوجهة',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
      };
}

