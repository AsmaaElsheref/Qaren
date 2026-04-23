import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/cart_item.dart';
import 'food_cart_state.dart';

/// Notifier that owns all cart mutations. Zero UI / BuildContext.
class FoodCartNotifier extends Notifier<FoodCartState> {
  @override
  FoodCartState build() => const FoodCartState();

  /// Add or increment an item in the cart.
  /// Requires item metadata for first-time additions.
  void increment(
    String itemId, {
    required String name,
    required String imageUrl,
    required double price,
  }) {
    final current = Map<String, CartItem>.from(state.items);
    final existing = current[itemId];
    if (existing != null) {
      current[itemId] = existing.copyWith(quantity: existing.quantity + 1);
    } else {
      current[itemId] = CartItem(
        id: itemId,
        name: name,
        imageUrl: imageUrl,
        price: price,
        quantity: 1,
      );
    }
    state = state.copyWith(items: current);
  }

  /// Decrement quantity of [itemId] by 1; removes entry when reaching 0.
  void decrement(String itemId) {
    final current = Map<String, CartItem>.from(state.items);
    final existing = current[itemId];
    if (existing == null) return;
    if (existing.quantity <= 1) {
      current.remove(itemId);
    } else {
      current[itemId] = existing.copyWith(quantity: existing.quantity - 1);
    }
    state = state.copyWith(items: current);
  }

  /// Remove an item completely from the cart.
  void remove(String itemId) {
    final current = Map<String, CartItem>.from(state.items);
    current.remove(itemId);
    state = state.copyWith(items: current);
  }

  /// Clear all items from the cart.
  void clear() => state = const FoodCartState();
}

// ── Providers ────────────────────────────────────────────────────────────────

final foodCartProvider =
    NotifierProvider<FoodCartNotifier, FoodCartState>(FoodCartNotifier.new);

/// Granular — total badge count only (minimises rebuild scope for header badge).
final foodCartTotalCountProvider = Provider<int>(
  (ref) => ref.watch(foodCartProvider.select((s) => s.totalCount)),
);

/// Family provider — quantity of a single item (minimises rebuild per card).
final foodItemQuantityProvider = Provider.family<int, String>(
  (ref, itemId) =>
      ref.watch(foodCartProvider.select((s) => s.quantityOf(itemId))),
);

/// Whether the cart is empty — drives empty/filled UI switch.
final foodCartIsEmptyProvider = Provider<bool>(
  (ref) => ref.watch(foodCartProvider.select((s) => s.isEmpty)),
);

/// Cart items list for the cart page.
final foodCartItemsProvider = Provider<List<CartItem>>(
  (ref) => ref.watch(foodCartProvider.select((s) => s.cartItems)),
);

/// Subtotal before tax.
final foodCartSubtotalProvider = Provider<double>(
  (ref) => ref.watch(foodCartProvider.select((s) => s.subtotal)),
);

/// Tax amount (15%).
final foodCartTaxProvider = Provider<double>(
  (ref) => ref.watch(foodCartProvider.select((s) => s.tax)),
);

/// Grand total.
final foodCartTotalProvider = Provider<double>(
  (ref) => ref.watch(foodCartProvider.select((s) => s.total)),
);

/// Map of cart product ids (as int, parsed from CartItem.id) → product name.
/// Used by the comparison screen to derive missing items for partial-match
/// restaurants. Rebuilds only when the cart keys change (not on qty changes).
final cartProductsNameMapProvider = Provider<Map<int, String>>(
  (ref) => ref.watch(
    foodCartProvider.select((s) {
      final map = <int, String>{};
      for (final item in s.items.values) {
        final id = int.tryParse(item.id);
        if (id != null) map[id] = item.name;
      }
      return map;
    }),
  ),
);

