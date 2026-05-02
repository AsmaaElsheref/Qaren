import 'package:equatable/equatable.dart';

import 'food_warehouse.dart';

/// Immutable model representing a single item in the cart
/// with all the display info needed by the cart page and the
/// data required by the booking API.
///
/// Each cart item carries its own selected branch/warehouse —
/// mixed warehouses across cart items are intentionally allowed.
class CartItem extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double? comparePrice;
  final int quantity;

  /// Selected branch/warehouse for this product (nullable when the
  /// product has no warehouses array yet — e.g. legacy data).
  final FoodWarehouse? warehouse;

  /// Optional modifiers (variant + addons) applied to this line.
  /// Stored generically so the booking layer can map them directly.
  final List<CartItemModifier> modifiers;

  /// Free-text instructions per item.
  final String specialInstructions;

  const CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.comparePrice,
    required this.quantity,
    this.warehouse,
    this.modifiers = const [],
    this.specialInstructions = '',
  });

  double get lineTotal => price * quantity;

  CartItem copyWith({
    int? quantity,
    FoodWarehouse? warehouse,
    List<CartItemModifier>? modifiers,
    String? specialInstructions,
  }) {
    return CartItem(
      id: id,
      name: name,
      imageUrl: imageUrl,
      price: price,
      comparePrice: comparePrice,
      quantity: quantity ?? this.quantity,
      warehouse: warehouse ?? this.warehouse,
      modifiers: modifiers ?? this.modifiers,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  @override
  List<Object?> get props => [id, quantity, warehouse?.foodProductWarehouseId];
}

/// Generic modifier line (variant or addon) stored on a cart item
/// and forwarded to the booking API as `modifiers[]`.
class CartItemModifier extends Equatable {
  final String name;
  final String value;
  final double price;

  const CartItemModifier({
    required this.name,
    required this.value,
    this.price = 0,
  });

  @override
  List<Object?> get props => [name, value, price];
}



