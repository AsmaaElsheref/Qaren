import 'package:equatable/equatable.dart';

/// Parameters required to search for car rental offers.
class CarRentalSearchParams extends Equatable {
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;

  const CarRentalSearchParams({
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'dropoff_lat': dropoffLat,
      'dropoff_lng': dropoffLng,
    };
  }

  @override
  List<Object?> get props => [
        pickupLat,
        pickupLng,
        dropoffLat,
        dropoffLng,
      ];
}

