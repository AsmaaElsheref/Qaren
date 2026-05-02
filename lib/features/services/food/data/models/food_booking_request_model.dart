import '../../domain/entities/cart_item.dart';
import 'food_booking_item_model.dart';

/// Body for POST /api/compare/booking.
///
/// Built from:
/// - the selected partner from the comparison screen
/// - the user's selected delivery address/location
/// - the current cart items (already carrying their own
///   `food_product_warehouse_id` from branch selection)
class FoodBookingRequestModel {
  const FoodBookingRequestModel({
    required this.mainPartnerId,
    this.deliveryType = 'delivery',
    this.paymentMethod = 'cash',
    required this.deliveryAddress,
    required this.deliveryLat,
    required this.deliveryLng,
    this.couponCode,
    this.customerNotes = '',
    required this.items,
  });

  final int mainPartnerId;
  final String deliveryType;
  final String paymentMethod;
  final String deliveryAddress;
  final double deliveryLat;
  final double deliveryLng;
  final String? couponCode;
  final String customerNotes;
  final List<FoodBookingItemModel> items;

  Map<String, dynamic> toJson() => {
        'main_partner_id': mainPartnerId,
        'delivery_type': deliveryType,
        'payment_method': paymentMethod,
        'delivery_address': deliveryAddress,
        'delivery_lat': deliveryLat,
        'delivery_lng': deliveryLng,
        'coupon_code': couponCode,
        'customer_notes': customerNotes,
        'items': items.map((i) => i.toJson()).toList(),
      };

  /// Build a request body from cart items, filtering out any cart entry
  /// that does not belong to [allowedProductIds] (used for partial-match
  /// restaurants where only matched items are ordered).
  ///
  /// Pass `null` for [allowedProductIds] to include every cart item
  /// (full match scenario).
  static FoodBookingRequestModel fromCart({
    required int mainPartnerId,
    required Iterable<CartItem> cartItems,
    required String deliveryAddress,
    required double deliveryLat,
    required double deliveryLng,
    Set<int>? allowedProductIds,
    String paymentMethod = 'cash',
    String deliveryType = 'delivery',
    String? couponCode,
    String customerNotes = '',
  }) {
    final items = <FoodBookingItemModel>[];
    for (final cartItem in cartItems) {
      if (allowedProductIds != null) {
        final productId = int.tryParse(cartItem.id);
        if (productId == null || !allowedProductIds.contains(productId)) {
          continue;
        }
      }
      final bookingItem = FoodBookingItemModel.fromCartItem(cartItem);
      if (bookingItem != null) items.add(bookingItem);
    }

    return FoodBookingRequestModel(
      mainPartnerId: mainPartnerId,
      paymentMethod: paymentMethod,
      deliveryType: deliveryType,
      deliveryAddress: deliveryAddress,
      deliveryLat: deliveryLat,
      deliveryLng: deliveryLng,
      couponCode: couponCode,
      customerNotes: customerNotes,
      items: items,
    );
  }
}

