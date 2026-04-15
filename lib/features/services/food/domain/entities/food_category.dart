import 'package:equatable/equatable.dart';

/// Immutable entity representing a food category filter chip.
class FoodCategory extends Equatable {
  final String id;
  final String name;

  const FoodCategory({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id];
}

