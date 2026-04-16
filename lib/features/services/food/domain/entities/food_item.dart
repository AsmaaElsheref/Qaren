import 'package:equatable/equatable.dart';

/// Immutable entity representing a single food menu item.
class FoodItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final double price;
  final double? comparePrice;
  final String currency;
  final int calories;
  final double rating;
  final int ratingCount;
  final String imageUrl;
  final String categoryId;
  final String categoryNameAr;
  final String categoryNameEn;
  final bool isAvailable;
  final bool isFeatured;
  final bool isNew;
  final int prepTimeMinutes;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    this.shortDescription = '',
    required this.price,
    this.comparePrice,
    this.currency = 'SAR',
    required this.calories,
    required this.rating,
    this.ratingCount = 0,
    required this.imageUrl,
    this.categoryId = '',
    this.categoryNameAr = '',
    this.categoryNameEn = '',
    this.isAvailable = true,
    this.isFeatured = false,
    this.isNew = false,
    this.prepTimeMinutes = 0,
  });

  @override
  List<Object?> get props => [id];
}
