import 'package:flutter/material.dart';

/// Sort options for the food price comparison screen.
enum FoodSortType { suggested, cheapest, fastest }

extension FoodSortTypeX on FoodSortType {
  String get label {
    switch (this) {
      case FoodSortType.suggested:
        return 'المقترح';
      case FoodSortType.cheapest:
        return 'الأرخص';
      case FoodSortType.fastest:
        return 'الأسرع';
    }
  }

  IconData get icon {
    switch (this) {
      case FoodSortType.suggested:
        return Icons.star_rounded;
      case FoodSortType.cheapest:
        return Icons.bolt_rounded;
      case FoodSortType.fastest:
        return Icons.access_time_rounded;
    }
  }
}

