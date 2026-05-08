import '../../domain/entities/booking_pricing_entity.dart';

class BookingPricingModel extends BookingPricingEntity {
  const BookingPricingModel({
    required super.totalPrice,
    required super.subtotal,
    required super.deliveryFee,
    required super.currency,
    required super.available,
  });

  factory BookingPricingModel.fromJson(Map<String, dynamic>? json) {
    return BookingPricingModel(
      totalPrice: parseDouble(json?['total_price']),
      subtotal: parseDouble(json?['subtotal']),
      deliveryFee: parseDouble(json?['delivery_fee']),
      currency: json?['currency'] as String? ?? 'SAR',
      available: json?['available'] as bool? ?? json != null,
    );
  }

  static double? parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

