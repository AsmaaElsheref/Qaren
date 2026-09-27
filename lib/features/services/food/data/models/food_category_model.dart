import 'dart:convert';

import 'package:intl/intl.dart';

import '../../domain/entities/food_category.dart';

/// Maps the `/compare/food-delivery/categories` JSON response
/// to the domain [FoodCategory] entity.
/// Reuses the existing entity — no duplicate model class needed.
class FoodCategoryModel {
  FoodCategoryModel._();

  static FoodCategory fromJson(Map<String, dynamic> json) {
    return FoodCategory(
      id: (json['id'] ?? json['category_id']).toString(),
      name: _localizedText(json['name'] ?? json['category_name']),
      slug: json['slug'] as String? ?? '',
      icon: (json['icon'] ?? json['category_icon']) as String? ?? '',
    );
  }

  static String _localizedText(dynamic value) {
    final locale = Intl.getCurrentLocale().toLowerCase();
    final languageCode = locale == 'ar' || locale.startsWith('ar_')
        ? 'ar'
        : 'en';
    return _localizedTextFor(value, languageCode);
  }

  static String _localizedTextFor(dynamic value, String languageCode) {
    if (value is String) {
      final text = value.trim();
      if (text.startsWith('{') && text.endsWith('}')) {
        try {
          return _localizedTextFor(jsonDecode(text), languageCode);
        } on FormatException {
          return value;
        }
      }
      return value;
    }
    if (value is Map) {
      return value[languageCode]?.toString() ??
          value['en']?.toString() ??
          value['ar']?.toString() ??
          '';
    }
    return '';
  }

  static List<FoodCategory> fromJsonList(List<dynamic> list) {
    return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }
}
