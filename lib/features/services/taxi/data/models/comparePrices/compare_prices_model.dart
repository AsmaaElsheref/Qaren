import 'package:flutter/material.dart';

// ── Sort options ─────────────────────────────────────────────────────────────

enum CompareSortType { suggested, cheapest, fastest }

extension CompareSortTypeX on CompareSortType {
  String get label {
    switch (this) {
      case CompareSortType.suggested:
        return 'المقترح';
      case CompareSortType.cheapest:
        return 'الأرخص';
      case CompareSortType.fastest:
        return 'الأسرع';
    }
  }

  IconData get icon {
    switch (this) {
      case CompareSortType.suggested:
        return Icons.star_rounded;
      case CompareSortType.cheapest:
        return Icons.bolt_rounded;
      case CompareSortType.fastest:
        return Icons.access_time_rounded;
    }
  }
}

// ── Price result model ───────────────────────────────────────────────────────

class PriceResult {
  final String id;
  final String appName;
  final String rideType;
  final double price;
  final double rating;
  final int estimatedMinutes;
  final Color iconBgColor;
  final Color iconColor;
  final IconData icon;
  final bool isBestValue;

  const PriceResult({
    required this.id,
    required this.appName,
    required this.rideType,
    required this.price,
    required this.rating,
    required this.estimatedMinutes,
    required this.iconBgColor,
    required this.iconColor,
    required this.icon,
    this.isBestValue = false,
  });
}

// ── Mock data ────────────────────────────────────────────────────────────────

const kMockPriceResults = <PriceResult>[
  PriceResult(
    id: 'uber_x',
    appName: 'أوبر إكس',
    rideType: 'اقتصادي',
    price: 32.5,
    rating: 4.8,
    estimatedMinutes: 12,
    iconBgColor: Color(0xFF1A1A1A),
    iconColor: Color(0xFFFFFFFF),
    icon: Icons.directions_car_rounded,
    isBestValue: true,
  ),
  PriceResult(
    id: 'careem_go',
    appName: 'كريم مريح',
    rideType: 'سيارة حديثة',
    price: 48.0,
    rating: 4.9,
    estimatedMinutes: 9,
    iconBgColor: Color(0xFF4CAF50),
    iconColor: Color(0xFFFFFFFF),
    icon: Icons.directions_car_filled_rounded,
  ),
  PriceResult(
    id: 'uber_black',
    appName: 'أوبر بلاك',
    rideType: 'فاخر',
    price: 65.0,
    rating: 4.9,
    estimatedMinutes: 15,
    iconBgColor: Color(0xFF1A1A1A),
    iconColor: Color(0xFFFFFFFF),
    icon: Icons.directions_car_rounded,
  ),
  PriceResult(
    id: 'careem_bus',
    appName: 'كريم باص',
    rideType: 'مشترك',
    price: 18.0,
    rating: 4.3,
    estimatedMinutes: 22,
    iconBgColor: Color(0xFF4CAF50),
    iconColor: Color(0xFFFFFFFF),
    icon: Icons.directions_bus_rounded,
  ),
];

