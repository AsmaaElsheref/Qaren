import 'package:equatable/equatable.dart';

/// Immutable entity representing a restaurant.
class Restaurant extends Equatable {
  final String id;
  final String name;
  final double rating;
  final String deliveryTime;
  final int menuCount;
  final String category;
  final String imageUrl;

  const Restaurant({
    required this.id,
    required this.name,
    required this.rating,
    required this.deliveryTime,
    required this.menuCount,
    required this.category,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id];
}

