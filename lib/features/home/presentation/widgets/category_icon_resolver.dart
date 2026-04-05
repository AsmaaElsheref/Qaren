import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Maps the API `icon` string (e.g. "car", "utensils") and `type` string
/// (e.g. "taxi", "food_delivery") to Flutter [IconData] and [Color].
///
/// This is a pure utility — no state, no side-effects.
class CategoryIconResolver {
  CategoryIconResolver._();

  // ── Icon map ──────────────────────────────────────────────────────────────

  static IconData resolve(String apiIcon) {
    return _iconMap[apiIcon] ?? Icons.category_outlined;
  }

  static const Map<String, IconData> _iconMap = {
    'car':           Icons.directions_car_outlined,
    'car-front':     Icons.car_rental_outlined,
    'utensils':      Icons.restaurant_menu_rounded,
    'plane':         Icons.flight_outlined,
    'building':      Icons.apartment_outlined,
    'shield-check':  Icons.verified_user_outlined,
    'shopping-bag':  Icons.shopping_bag_outlined,
    'hammer':        Icons.handyman_outlined,
    'truck':         Icons.local_shipping_outlined,
    'package':       Icons.inventory_2_outlined,
    'scissors':      Icons.cut,
    'ticket':        Icons.confirmation_num_outlined,
  };

  // ── Color map (keyed by API `type`) ───────────────────────────────────────

  static Color colorFor(String type) {
    return _colorMap[type] ?? AppColors.primary;
  }

  static const Map<String, Color> _colorMap = {
    'taxi':           Color(0xFFFF9500),
    'food_delivery':  Color(0xFFE85D5D),
    'flights':        Color(0xFF5B9BD5),
    'hotels':         Color(0xFF6B7FD7),
    'insurance':      Color(0xFF1DB899),
    'car_rental':     Color(0xFF9B7FD7),
    'shopping':       Color(0xFFE85D9A),
    'home_services':  Color(0xFFD4A017),
    'furniture':      Color(0xFF6B7280),
    'parcel':         Color(0xFF1DB899),
    'salon':          Color(0xFFE85D5D),
    'events':         Color(0xFF5B9BD5),
  };
}

