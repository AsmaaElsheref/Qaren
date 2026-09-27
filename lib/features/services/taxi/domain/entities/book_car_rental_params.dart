import 'package:equatable/equatable.dart';

/// Parameters required to book a taxi trip.
class BookCarRentalParams extends Equatable {
  final String userId;
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final String carId;
  final String paymentMethod;

  const BookCarRentalParams({
    required this.userId,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.carId,
    this.paymentMethod = 'cash',
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'carId': carId,
    'pickup': {'lat': pickupLat, 'lng': pickupLng},
    'destination': {'lat': dropoffLat, 'lng': dropoffLng},
    'paymentMethod': paymentMethod,
  };

  @override
  List<Object?> get props => [
    userId,
    pickupLat,
    pickupLng,
    dropoffLat,
    dropoffLng,
    carId,
    paymentMethod,
  ];
}
