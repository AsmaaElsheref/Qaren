import 'package:equatable/equatable.dart';

/// Immutable entity representing a single food menu item.
class FoodItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final int calories;
  final double rating;
  final String imageUrl;
  final String restaurantId;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.calories,
    required this.rating,
    required this.imageUrl,
    required this.restaurantId,
  });

  @override
  List<Object?> get props => [id];
}

