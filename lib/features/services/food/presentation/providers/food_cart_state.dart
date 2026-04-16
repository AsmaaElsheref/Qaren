import 'package:equatable/equatable.dart';

import '../../domain/entities/cart_item.dart';

/// Immutable state for the food cart.
/// Maps item IDs to [CartItem] objects with full display info.
class FoodCartState extends Equatable {
  final Map<String, CartItem> items;

  const FoodCartState({this.items = const {}});

  /// Quantity of a single item (0 if absent).
  int quantityOf(String itemId) => items[itemId]?.quantity ?? 0;

  /// Total number of items in the cart (sum of all quantities).
  int get totalCount =>
      items.values.fold(0, (sum, item) => sum + item.quantity);

  /// Whether the cart has any items.
  bool get isEmpty => items.isEmpty;

  /// Ordered list of cart items for display.
  List<CartItem> get cartItems => items.values.toList();

  /// Subtotal before tax.
  double get subtotal =>
      items.values.fold(0.0, (sum, item) => sum + item.lineTotal);

  /// Tax amount (15%).
  double get tax => subtotal * 0.15;

  /// Grand total including tax.
  double get total => subtotal + tax;

  FoodCartState copyWith({Map<String, CartItem>? items}) {
    return FoodCartState(
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [items];
}

