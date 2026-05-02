import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/cart_item.dart';
import 'food_cart_provider.dart';
import 'food_comparison_provider.dart';

/// The list of cart items that will actually be sent to the booking API.
///
/// For full-match partners → returns the entire cart.
/// For partial-match partners → filters cart items to those whose product id
/// is present in the partner's `productsPreview`.
///
/// Derived state — keeps the checkout screen lean and avoids duplicating
/// filtering logic across widgets.
final checkoutItemsProvider = Provider<List<CartItem>>((ref) {
  final cart = ref.watch(foodCartItemsProvider);
  final partner = ref.watch(selectedProviderForBookingProvider);
  if (partner == null) return cart;

  final isPartial = partner.totalRequested > 0 &&
      partner.matchedCount < partner.totalRequested;
  if (!isPartial) return cart;

  final allowed = partner.productsPreview.map((p) => p.id).toSet();
  return cart
      .where((c) => allowed.contains(int.tryParse(c.id)))
      .toList(growable: false);
});

/// Sum of (unit price × quantity) for the items going into the booking.
final checkoutSubtotalProvider = Provider<double>((ref) {
  final items = ref.watch(checkoutItemsProvider);
  return items.fold<double>(0, (sum, i) => sum + i.lineTotal);
});

/// Total count of items in the checkout (sum of quantities).
final checkoutItemsCountProvider = Provider<int>((ref) {
  final items = ref.watch(checkoutItemsProvider);
  return items.fold<int>(0, (sum, i) => sum + i.quantity);
});

