import 'package:equatable/equatable.dart';
import '../../../data/models/comparePrices/compare_prices_model.dart';

enum ComparePricesStatus { initial, loading, success, empty, failure }

/// Immutable state for the compare prices screen.
class ComparePricesState extends Equatable {
  final ComparePricesStatus status;
  final List<PriceResult> results;
  final CompareSortType sortType;
  final String? errorMessage;

  const ComparePricesState({
    this.status = ComparePricesStatus.initial,
    this.results = const [],
    this.sortType = CompareSortType.suggested,
    this.errorMessage,
  });

  List<PriceResult> get sorted {
    final list = List<PriceResult>.from(results);
    switch (sortType) {
      case CompareSortType.suggested:
        list.sort((a, b) {
          if (a.isBestValue != b.isBestValue) {
            return a.isBestValue ? -1 : 1;
          }
          return a.price.compareTo(b.price);
        });
      case CompareSortType.cheapest:
        list.sort((a, b) => a.price.compareTo(b.price));
      case CompareSortType.fastest:
        list.sort((a, b) => a.distanceValue.compareTo(b.distanceValue));
    }
    return list;
  }

  ComparePricesState copyWith({
    ComparePricesStatus? status,
    List<PriceResult>? results,
    CompareSortType? sortType,
    String? errorMessage,
  }) =>
      ComparePricesState(
        status: status ?? this.status,
        results: results ?? this.results,
        sortType: sortType ?? this.sortType,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, results, sortType, errorMessage];
}

