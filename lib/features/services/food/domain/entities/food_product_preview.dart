import 'package:equatable/equatable.dart';

/// Lightweight product preview inside a compare-result partner card.
class FoodProductPreview extends Equatable {
  final int id;
  final String name;
  final double price;
  final String thumbnail;
  final double? rating;
  final int? prepTimeMin;

  const FoodProductPreview({
    required this.id,
    required this.name,
    required this.price,
    required this.thumbnail,
    this.rating,
    this.prepTimeMin,
  });

  @override
  List<Object?> get props => [id];
}

