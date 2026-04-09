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
  final String currency;
  final double? totalPrice;
  final double rating;
  final String? distance;
  final Color iconBgColor;
  final Color iconColor;
  final String icon;
  final bool isBestValue;

  const PriceResult({
    required this.id,
    required this.appName,
    required this.rideType,
    required this.price,
    this.currency = 'SAR',
    this.totalPrice,
    required this.rating,
    required this.distance,
    required this.iconBgColor,
    required this.iconColor,
    required this.icon,
    this.isBestValue = false,
  });

  /// Parses the numeric value from a distance string like "4 km away" → 4.0.
  /// Returns [double.infinity] when null or unparseable so nulls sort last.
  double get distanceValue {
    if (distance == null) return double.infinity;
    final match = RegExp(r'[\d.]+').firstMatch(distance!);
    if (match == null) return double.infinity;
    return double.tryParse(match.group(0)!) ?? double.infinity;
  }
}


