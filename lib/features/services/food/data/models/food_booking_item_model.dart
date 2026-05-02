import '../../domain/entities/cart_item.dart';

/// Single line in the booking request body.
///
/// Built directly from a [CartItem]. The cart item already holds the
/// selected branch (`food_product_warehouse_id`), so no guessing happens
/// at booking time.
class FoodBookingItemModel {
  const FoodBookingItemModel({
    required this.foodProductWarehouseId,
    required this.quantity,
    required this.unitPrice,
    this.comparePrice,
    this.modifiers = const [],
    this.specialInstructions = '',
  });

  final int foodProductWarehouseId;
  final int quantity;
  final double unitPrice;
  final double? comparePrice;
  final List<CartItemModifier> modifiers;
  final String specialInstructions;

  Map<String, dynamic> toJson() => {
        'food_product_warehouse_id': foodProductWarehouseId,
        'quantity': quantity,
        if (comparePrice != null) 'compare_price': comparePrice,
        'unit_price': unitPrice,
        'modifiers': modifiers
            .map((m) => {
                  'name': m.name,
                  'value': m.value,
                  'price': m.price,
                })
            .toList(),
        'special_instructions': specialInstructions,
      };

  /// Builds a booking item from a single cart item.
  /// Returns null if the cart item has no selected warehouse — the caller
  /// must surface a branch-selection error instead of guessing.
  static FoodBookingItemModel? fromCartItem(CartItem item) {
    final wh = item.warehouse;
    if (wh == null) return null;
    return FoodBookingItemModel(
      foodProductWarehouseId: wh.foodProductWarehouseId,
      quantity: item.quantity,
      unitPrice: item.price,
      comparePrice: item.comparePrice,
      modifiers: item.modifiers,
      specialInstructions: item.specialInstructions,
    );
  }
}

