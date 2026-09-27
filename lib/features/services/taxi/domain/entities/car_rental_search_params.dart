import 'package:equatable/equatable.dart';

/// Parameters required to search for car rental offers.
class CarRentalSearchParams extends Equatable {
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final String carType;
  final bool useFakeData;

  const CarRentalSearchParams({
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    this.carType = 'luxury',
    this.useFakeData = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'pickup': {'lat': pickupLat, 'lng': pickupLng},
      'destination': {'lat': dropoffLat, 'lng': dropoffLng},
      'filters': {'carType': carType},
      'useFakeData': useFakeData,
    };
  }

  @override
  List<Object?> get props => [
    pickupLat,
    pickupLng,
    dropoffLat,
    dropoffLng,
    carType,
    useFakeData,
  ];
}
