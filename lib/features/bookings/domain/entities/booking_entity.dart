import 'package:equatable/equatable.dart';

import 'booking_pricing_entity.dart';
import 'booking_service_type.dart';
import 'car_rental_booking_entity.dart';
import 'food_order_booking_entity.dart';

class BookingEntity extends Equatable {
  final int id;
  final BookingServiceType serviceType;
  final String serviceTypeRaw;
  final String providerSlug;
  final String bookingReference;
  final String status;
  final String statusLabel;
  final BookingPricingEntity pricing;
  final String bookedAt;
  final String bookedAtLabel;
  final FoodOrderBookingEntity? foodOrder;
  final CarRentalBookingEntity? carRental;

  const BookingEntity({
    required this.id,
    required this.serviceType,
    required this.serviceTypeRaw,
    required this.providerSlug,
    required this.bookingReference,
    required this.status,
    required this.statusLabel,
    required this.pricing,
    required this.bookedAt,
    required this.bookedAtLabel,
    required this.foodOrder,
    required this.carRental,
  });

  @override
  List<Object?> get props => [
        id,
        serviceType,
        serviceTypeRaw,
        providerSlug,
        bookingReference,
        status,
        statusLabel,
        pricing,
        bookedAt,
        bookedAtLabel,
        foodOrder,
        carRental,
      ];
}

