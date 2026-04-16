import '../../domain/entities/food_category.dart';

/// Maps the `/api/compare/food-delivery/categories` JSON response
/// to the domain [FoodCategory] entity.
/// Reuses the existing entity — no duplicate model class needed.
class FoodCategoryModel {
  FoodCategoryModel._();

  static FoodCategory fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>?;
    return FoodCategory(
      id: json['id'].toString(),
      name: name?['ar'] as String? ?? name?['en'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }

  static List<FoodCategory> fromJsonList(List<dynamic> list) {
    return list
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

