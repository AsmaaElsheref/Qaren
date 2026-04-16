import 'package:equatable/equatable.dart';

/// Immutable entity representing a food category filter chip.
class FoodCategory extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String icon;

  const FoodCategory({
    required this.id,
    required this.name,
    this.slug = '',
    this.icon = '',
  });

  @override
  List<Object?> get props => [id];
}

