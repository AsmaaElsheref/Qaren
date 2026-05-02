import 'package:flutter/foundation.dart';

/// Represents a single child item inside the booking response.
@immutable
class FoodBookingItemResponse {
  const FoodBookingItemResponse({
    required this.id,
    required this.foodProductWarehouseId,
    required this.quantity,
    required this.unitPrice,
    required this.comparePrice,
    required this.subtotal,
    required this.modifiers,
    required this.modifiersPrice,
    required this.productNameSnapshot,
    required this.productThumbnailSnapshot,
    this.specialInstructions,
  });

  final int id;
  final int foodProductWarehouseId;
  final int quantity;
  final double unitPrice;
  final double comparePrice;
  final double subtotal;
  final List<Map<String, dynamic>> modifiers;
  final double modifiersPrice;

  /// Multilingual snapshot: {"ar": "...", "en": "..."}
  final Map<String, String> productNameSnapshot;
  final String productThumbnailSnapshot;
  final String? specialInstructions;

  String get nameAr => productNameSnapshot['ar'] ?? productNameSnapshot['en'] ?? '';
  String get nameEn => productNameSnapshot['en'] ?? productNameSnapshot['ar'] ?? '';

  /// Returns the Arabic name if available, otherwise English, otherwise empty.
  String get displayName => nameAr.isNotEmpty ? nameAr : nameEn;

  factory FoodBookingItemResponse.fromJson(Map<String, dynamic> json) {
    // modifiers can be null or a list
    final rawModifiers = json['modifiers'];
    final List<Map<String, dynamic>> modifiers = rawModifiers == null
        ? []
        : (rawModifiers as List<dynamic>)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();

    // name snapshot can be a Map or null
    final rawName = json['product_name_snapshot'];
    final Map<String, String> nameSnapshot = rawName == null
        ? {}
        : (rawName as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, v?.toString() ?? ''));

    return FoodBookingItemResponse(
      id: json['id'] as int,
      foodProductWarehouseId:
          int.tryParse(json['food_product_warehouse_id'].toString()) ?? 0,
      quantity: json['quantity'] as int,
      unitPrice: double.tryParse(json['unit_price'].toString()) ?? 0,
      comparePrice: double.tryParse(json['compare_price'].toString()) ?? 0,
      subtotal: double.tryParse(json['subtotal'].toString()) ?? 0,
      modifiers: modifiers,
      modifiersPrice:
          double.tryParse(json['modifiers_price'].toString()) ?? 0,
      productNameSnapshot: nameSnapshot,
      productThumbnailSnapshot:
          json['product_thumbnail_snapshot']?.toString() ?? '',
      specialInstructions: json['special_instructions']?.toString(),
    );
  }

  static List<FoodBookingItemResponse> fromJsonList(List<dynamic> list) =>
      list
          .map((e) => FoodBookingItemResponse.fromJson(
              e as Map<String, dynamic>))
          .toList();
}

