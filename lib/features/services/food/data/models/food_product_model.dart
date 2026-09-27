import 'dart:convert';

import 'package:intl/intl.dart';

import '../../../../../core/network/apiRoutes/api_routes.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/food_warehouse.dart';

/// Model that maps the API JSON response to domain [FoodItem].
class FoodProductModel {
  const FoodProductModel._();

  static FoodItem fromJson(Map<String, dynamic> json) {
    final nutrition = json['nutrition'] as Map<String, dynamic>?;
    final category = json['category'] as Map<String, dynamic>?;
    final categoryName = category?['name'];
    final warehousesJson = json['warehouses'] as List<dynamic>?;
    final seo = json['seo'] as Map<String, dynamic>?;
    final languageCode = _currentLanguageCode;
    final shortDescription = _localizedText(
      json['short_description'],
      languageCode: languageCode,
    );
    final name = _firstNotEmpty([
      _localizedText(json['name'], languageCode: languageCode),
      _localizedText(seo?['meta_title'], languageCode: languageCode),
      _humanizeSlug(json['slug']?.toString() ?? ''),
    ]);
    final description = _firstNotEmpty([
      _localizedText(json['description'], languageCode: languageCode),
      shortDescription,
      _localizedText(seo?['meta_description'], languageCode: languageCode),
    ]);

    return FoodItem(
      id: (json['id'] ?? json['product_id']).toString(),
      name: name,
      description: description,
      shortDescription: shortDescription,
      price: _asDouble(json['price']) ?? 0,
      comparePrice: _asDouble(json['compare_price']),
      currency: json['currency'] as String? ?? 'SAR',
      calories: int.tryParse(nutrition?['calories']?.toString() ?? '') ?? 0,
      rating: _asDouble(json['rating']) ?? 0,
      ratingCount: int.tryParse(json['rating_count']?.toString() ?? '') ?? 0,
      imageUrl: ApiRoutes.foodImageUrl(json['thumbnail'] as String? ?? ''),
      categoryId: json['category_id']?.toString() ?? '',
      categoryNameAr: _localizedText(categoryName, languageCode: 'ar'),
      categoryNameEn: _localizedText(categoryName, languageCode: 'en'),
      isAvailable: json['is_available'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      isNew: json['is_new'] as bool? ?? false,
      prepTimeMinutes:
          int.tryParse(
            (json['prep_time_min'] ?? json['prep_time_minutes'])?.toString() ??
                '',
          ) ??
          0,
      warehouses: warehousesJson == null
          ? const []
          : warehousesJson
                .whereType<Map<String, dynamic>>()
                .map(_warehouseFromJson)
                .toList(growable: false),
    );
  }

  static double? _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  static String _localizedText(dynamic value, {required String languageCode}) {
    if (value is String) {
      final text = value.trim();
      if (text.startsWith('{') && text.endsWith('}')) {
        try {
          return _localizedText(jsonDecode(text), languageCode: languageCode);
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

  static String get _currentLanguageCode {
    final locale = Intl.getCurrentLocale().toLowerCase();
    return locale == 'ar' || locale.startsWith('ar_') ? 'ar' : 'en';
  }

  static String _firstNotEmpty(Iterable<String> values) {
    return values.firstWhere(
      (value) => value.trim().isNotEmpty,
      orElse: () => '',
    );
  }

  static String _humanizeSlug(String slug) {
    if (slug.isEmpty) return '';
    return slug
        .split(RegExp(r'[-_]'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  static FoodWarehouse _warehouseFromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;
    return FoodWarehouse(
      foodProductWarehouseId:
          int.tryParse(json['food_product_warehouse_id']?.toString() ?? '') ??
          0,
      warehouseId: int.tryParse(json['warehouse_id']?.toString() ?? '') ?? 0,
      name: json['name'] as String? ?? '',
      city: json['city'] as String? ?? '',
      area: json['area'] as String? ?? '',
      address: json['address'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      latitude: _asDouble(location?['latitude']),
      longitude: _asDouble(location?['longitude']),
    );
  }

  static List<FoodItem> fromJsonList(List<dynamic> list) {
    return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }
}
