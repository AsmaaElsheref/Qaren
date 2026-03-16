import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/comparePrices/compare_prices_model.dart';

// ── State ────────────────────────────────────────────────────────────────────

class ComparePricesState {
  final List<PriceResult> results;
  final CompareSortType sortType;

  const ComparePricesState({
    this.results = kMockPriceResults,
    this.sortType = CompareSortType.suggested,
  });

  List<PriceResult> get sorted {
    final list = List<PriceResult>.from(results);
    switch (sortType) {
      case CompareSortType.suggested:
        // Best value first, then by price
        list.sort((a, b) {
          if (a.isBestValue != b.isBestValue) {
            return a.isBestValue ? -1 : 1;
          }
          return a.price.compareTo(b.price);
        });
      case CompareSortType.cheapest:
        list.sort((a, b) => a.price.compareTo(b.price));
      case CompareSortType.fastest:
        list.sort((a, b) => a.estimatedMinutes.compareTo(b.estimatedMinutes));
    }
    return list;
  }

  ComparePricesState copyWith({
    List<PriceResult>? results,
    CompareSortType? sortType,
  }) =>
      ComparePricesState(
        results: results ?? this.results,
        sortType: sortType ?? this.sortType,
      );
}

// ── Notifier ─────────────────────────────────────────────────────────────────

class ComparePricesNotifier extends Notifier<ComparePricesState> {
  @override
  ComparePricesState build() => const ComparePricesState();

  void setSort(CompareSortType sort) =>
      state = state.copyWith(sortType: sort);
}

// ── Providers ────────────────────────────────────────────────────────────────

final comparePricesProvider =
    NotifierProvider<ComparePricesNotifier, ComparePricesState>(
  ComparePricesNotifier.new,
);

/// Granular — only the active sort type; avoids full list rebuilds.
final compareSortTypeProvider = Provider<CompareSortType>(
  (ref) => ref.watch(
    comparePricesProvider.select((s) => s.sortType),
  ),
);

/// Granular — the sorted result list.
final compareSortedResultsProvider = Provider<List<PriceResult>>(
  (ref) => ref.watch(
    comparePricesProvider.select((s) => s.sorted),
  ),
);

