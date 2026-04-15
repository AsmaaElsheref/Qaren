import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'food_cart_state.dart';

/// Notifier that owns all cart mutations. Zero UI / BuildContext.
class FoodCartNotifier extends Notifier<FoodCartState> {
  @override
  FoodCartState build() => const FoodCartState();

  /// Increment quantity of [itemId] by 1.
  void increment(String itemId) {
    final current = Map<String, int>.from(state.quantities);
    current[itemId] = (current[itemId] ?? 0) + 1;
    state = state.copyWith(quantities: current);
  }

  /// Decrement quantity of [itemId] by 1; removes entry when reaching 0.
  void decrement(String itemId) {
    final current = Map<String, int>.from(state.quantities);
    final qty = (current[itemId] ?? 0) - 1;
    if (qty <= 0) {
      current.remove(itemId);
    } else {
      current[itemId] = qty;
    }
    state = state.copyWith(quantities: current);
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

