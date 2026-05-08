import '../../domain/entities/car_rental_booking_entity.dart';

class CarRentalBookingModel extends CarRentalBookingEntity {
  const CarRentalBookingModel({
    required super.offerId,
    required super.customerName,
    required super.customerPhone,
  });

  factory CarRentalBookingModel.fromJson(Map<String, dynamic>? json) {
    return CarRentalBookingModel(
      offerId: parseInt(json?['offer_id']),
      customerName: json?['customer_name'] as String? ?? '',
      customerPhone: json?['customer_phone'] as String? ?? '',
    );
  }

  static int? parseInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}

