import '../../domain/entities/food_item.dart';

/// Model that maps the API JSON response to domain [FoodItem].
class FoodProductModel {
  const FoodProductModel._();

  static FoodItem fromJson(Map<String, dynamic> json) {
    final nutrition = json['nutrition'] as Map<String, dynamic>?;
    final category = json['category'] as Map<String, dynamic>?;
    final categoryName = category?['name'] as Map<String, dynamic>?;

    return FoodItem(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      shortDescription: json['short_description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      comparePrice: (json['compare_price'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'SAR',
      calories: int.tryParse(nutrition?['calories']?.toString() ?? '') ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      ratingCount: int.tryParse(json['rating_count']?.toString() ?? '') ?? 0,
      imageUrl: json['thumbnail'] as String? ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      categoryNameAr: categoryName?['ar'] as String? ?? '',
      categoryNameEn: categoryName?['en'] as String? ?? '',
      isAvailable: json['is_available'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      isNew: json['is_new'] as bool? ?? false,
      prepTimeMinutes: int.tryParse(json['prep_time_minutes']?.toString() ?? '') ?? 0,
    );
  }

  static List<FoodItem> fromJsonList(List<dynamic> list) {
    return list
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

