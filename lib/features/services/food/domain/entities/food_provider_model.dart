import 'package:equatable/equatable.dart';

/// Immutable model representing a food delivery provider
/// used in price comparison results.
class FoodProviderModel extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double rating;
  final int deliveryTimeMinutes;
  final bool isBestValue;
  final String tag;
  const FoodProviderModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.deliveryTimeMinutes,
    this.isBestValue = false,
    required this.tag,
  });
  @override
  List<Object?> get props => [id];
}