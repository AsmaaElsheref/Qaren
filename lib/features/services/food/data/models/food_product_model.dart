import '../../domain/entities/food_item.dart';
import '../../domain/entities/food_warehouse.dart';

/// Model that maps the API JSON response to domain [FoodItem].
class FoodProductModel {
  const FoodProductModel._();

  static FoodItem fromJson(Map<String, dynamic> json) {
    final nutrition = json['nutrition'] as Map<String, dynamic>?;
    final category = json['category'] as Map<String, dynamic>?;
    final categoryName = category?['name'] as Map<String, dynamic>?;
    final warehousesJson = json['warehouses'] as List<dynamic>?;

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
      prepTimeMinutes:
          int.tryParse(json['prep_time_minutes']?.toString() ?? '') ?? 0,
      warehouses: warehousesJson == null
          ? const []
          : warehousesJson
              .whereType<Map<String, dynamic>>()
              .map(_warehouseFromJson)
              .toList(growable: false),
    );
  }

  static FoodWarehouse _warehouseFromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;
    return FoodWarehouse(
      foodProductWarehouseId:
          int.tryParse(json['food_product_warehouse_id']?.toString() ?? '') ??
              0,
      warehouseId:
          int.tryParse(json['warehouse_id']?.toString() ?? '') ?? 0,
      name: json['name'] as String? ?? '',
      city: json['city'] as String? ?? '',
      area: json['area'] as String? ?? '',
      address: json['address'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      latitude: (location?['latitude'] as num?)?.toDouble(),
      longitude: (location?['longitude'] as num?)?.toDouble(),
    );
  }

  static List<FoodItem> fromJsonList(List<dynamic> list) {
    return list
        .map((e) => fromJson(e as Map<String, dynamic>))
        .toList();
  }
}



