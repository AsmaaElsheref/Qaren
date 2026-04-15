import 'package:equatable/equatable.dart';

/// Immutable state for the food cart.
/// Maps item IDs to their quantities.
class FoodCartState extends Equatable {
  final Map<String, int> quantities;

  const FoodCartState({this.quantities = const {}});

  int quantityOf(String itemId) => quantities[itemId] ?? 0;

  int get totalCount =>
      quantities.values.fold(0, (sum, qty) => sum + qty);

  FoodCartState copyWith({Map<String, int>? quantities}) {
    return FoodCartState(
      quantities: quantities ?? this.quantities,
    );
  }

  @override
  List<Object?> get props => [quantities];
}

