import 'package:equatable/equatable.dart';

/// Parameters required to search for car rental offers.
class CarRentalSearchParams extends Equatable {
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final String pickupDate;
  final String returnDate;

  const CarRentalSearchParams({
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.pickupDate,
    required this.returnDate,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'dropoff_lat': dropoffLat,
      'dropoff_lng': dropoffLng,
      'pickup_date': pickupDate,
      'return_date': returnDate,
    };
  }

  @override
  List<Object?> get props => [
        pickupLat,
        pickupLng,
        dropoffLat,
        dropoffLng,
        pickupDate,
        returnDate,
      ];
}

