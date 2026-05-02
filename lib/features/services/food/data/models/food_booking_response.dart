import 'package:flutter/foundation.dart';

import 'food_booking_item_response.dart';

/// Top-level response from POST /api/compare/booking.
@immutable
class FoodBookingResponse {
  const FoodBookingResponse({
    required this.id,
    required this.bookingNumber,
    required this.status,
    required this.subtotal,
    required this.discountAmount,
    required this.deliveryFee,
    required this.taxAmount,
    required this.totalPrice,
    required this.currency,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.deliveryType,
    required this.deliveryAddress,
    required this.deliveryLat,
    required this.deliveryLng,
    required this.customerNotes,
    required this.children,
    this.estimatedDeliveryMinutes,
    this.couponCode,
  });

  final int id;
  final String bookingNumber;
  final String status;
  final double subtotal;
  final double discountAmount;
  final double deliveryFee;
  final double taxAmount;
  final double totalPrice;
  final String currency;
  final String paymentMethod;
  final String paymentStatus;
  final String deliveryType;
  final String deliveryAddress;
  final double deliveryLat;
  final double deliveryLng;
  final String customerNotes;
  final List<FoodBookingItemResponse> children;
  final int? estimatedDeliveryMinutes;
  final String? couponCode;

  factory FoodBookingResponse.fromJson(Map<String, dynamic> json) {
    // Response wraps data in a "data" key
    final data = (json['data'] ?? json) as Map<String, dynamic>;

    final rawChildren = data['children'] as List<dynamic>? ?? [];

    return FoodBookingResponse(
      id: data['id'] as int? ?? 0,
      bookingNumber: data['booking_number']?.toString() ?? '',
      status: data['status']?.toString() ?? '',
      subtotal: double.tryParse(data['subtotal'].toString()) ?? 0,
      discountAmount:
          double.tryParse(data['discount_amount'].toString()) ?? 0,
      deliveryFee: double.tryParse(data['delivery_fee'].toString()) ?? 0,
      taxAmount: double.tryParse(data['tax_amount'].toString()) ?? 0,
      totalPrice: double.tryParse(data['total_price'].toString()) ?? 0,
      currency: data['currency']?.toString() ?? 'SAR',
      paymentMethod: data['payment_method']?.toString() ?? 'cash',
      paymentStatus: data['payment_status']?.toString() ?? '',
      deliveryType: data['delivery_type']?.toString() ?? 'delivery',
      deliveryAddress: data['delivery_address']?.toString() ?? '',
      deliveryLat:
          double.tryParse(data['delivery_lat'].toString()) ?? 0,
      deliveryLng:
          double.tryParse(data['delivery_lng'].toString()) ?? 0,
      customerNotes: data['customer_notes']?.toString() ?? '',
      children: FoodBookingItemResponse.fromJsonList(rawChildren),
      estimatedDeliveryMinutes:
          data['estimated_delivery_minutes'] as int?,
      couponCode: data['coupon_code']?.toString(),
    );
  }
}

