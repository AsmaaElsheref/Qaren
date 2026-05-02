import 'package:flutter_riverpod/flutter_riverpod.dart';

/// User-entered customer notes for the booking — local form state.
/// Owned by the checkout screen; reset by the screen's lifecycle.
final checkoutNotesProvider = StateProvider<String>((ref) => '');

/// Selected payment method. Hard-coded to "cash" today, but kept as state
/// so future methods (card, wallet…) can be added without UI rewrites.
final checkoutPaymentMethodProvider =
    StateProvider<String>((ref) => 'cash');

/// Optional coupon code the user enters at checkout.
final checkoutCouponProvider = StateProvider<String?>((ref) => null);

