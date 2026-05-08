import '../../domain/entities/food_order_booking_entity.dart';

class FoodOrderBookingModel extends FoodOrderBookingEntity {
  const FoodOrderBookingModel({
    required super.bookingId,
    required super.partnerId,
    required super.deliveryType,
    required super.deliveryAddress,
    required super.itemsCount,
    required super.customerNotes,
    required super.paymentMethod,
    required super.paymentStatus,
  });

  factory FoodOrderBookingModel.fromJson(Map<String, dynamic>? json) {
    return FoodOrderBookingModel(
      bookingId: parseInt(json?['booking_id']),
      partnerId: parseInt(json?['partner_id']),
      deliveryType: json?['delivery_type'] as String? ?? '',
      deliveryAddress: json?['delivery_address'] as String? ?? '',
      itemsCount: parseInt(json?['items_count']),
      customerNotes: json?['customer_notes'] as String? ?? '',
      paymentMethod: json?['payment_method'] as String? ?? '',
      paymentStatus: json?['payment_status'] as String? ?? '',
    );
  }

  static int? parseInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}

