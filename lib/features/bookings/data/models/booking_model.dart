import 'package:intl/intl.dart';

import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/booking_service_type.dart';
import 'booking_pricing_model.dart';
import 'car_rental_booking_model.dart';
import 'food_order_booking_model.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.serviceType,
    required super.serviceTypeRaw,
    required super.providerSlug,
    required super.bookingReference,
    required super.status,
    required super.statusLabel,
    required super.pricing,
    required super.bookedAt,
    required super.bookedAtLabel,
    required super.foodOrder,
    required super.carRental,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final serviceTypeRaw = json['service_type'] as String? ?? '';
    final status = json['status'] as String? ?? '';

    return BookingModel(
      id: parseInt(json['id']) ?? 0,
      serviceType: BookingServiceType.fromApi(serviceTypeRaw),
      serviceTypeRaw: serviceTypeRaw,
      providerSlug: json['provider_slug'] as String? ?? '',
      bookingReference: json['booking_reference'] as String? ?? '',
      status: status,
      statusLabel: json['status_label'] as String? ?? status,
      pricing: BookingPricingModel.fromJson(asMap(json['pricing'])),
      bookedAt: json['booked_at'] as String? ?? '',
      bookedAtLabel: formatBookedAt(json['booked_at'] as String?),
      foodOrder: json['food_order'] == null
          ? null
          : FoodOrderBookingModel.fromJson(asMap(json['food_order'])),
      carRental: json['car_rental'] == null
          ? null
          : CarRentalBookingModel.fromJson(asMap(json['car_rental'])),
    );
  }

  static Map<String, dynamic>? asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static int? parseInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static String formatBookedAt(String? value) {
    if (value == null || value.isEmpty) return '';
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    return DateFormat('yyyy/MM/dd - HH:mm').format(date.toLocal());
  }
}

