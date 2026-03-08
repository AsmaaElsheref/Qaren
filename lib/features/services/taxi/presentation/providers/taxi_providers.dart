import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── State ────────────────────────────────────────────────────────────────────

class TaxiState {
  final String pickup;
  final String destination;
  final bool isLoading;

  const TaxiState({
    this.pickup = '',
    this.destination = '',
    this.isLoading = false,
  });

  TaxiState copyWith({
    String? pickup,
    String? destination,
    bool? isLoading,
  }) =>
      TaxiState(
        pickup: pickup ?? this.pickup,
        destination: destination ?? this.destination,
        isLoading: isLoading ?? this.isLoading,
      );
}

// ── Notifier ─────────────────────────────────────────────────────────────────

class TaxiNotifier extends Notifier<TaxiState> {
  @override
  TaxiState build() => const TaxiState();

  void setPickup(String value) =>
      state = state.copyWith(pickup: value);

  void setDestination(String value) =>
      state = state.copyWith(destination: value);

  Future<void> comparePrices() async {
    if (state.pickup.isEmpty || state.destination.isEmpty) return;
    state = state.copyWith(isLoading: true);
    // TODO: call actual price-comparison use-case
    await Future<void>.delayed(const Duration(seconds: 2));
    state = state.copyWith(isLoading: false);
  }
}

final taxiProvider =
    NotifierProvider<TaxiNotifier, TaxiState>(TaxiNotifier.new);

// ── Granular selectors (each widget rebuilds only for its own slice) ──────────

/// True only when the compare button should be active.
final taxiCanCompareProvider = Provider<bool>(
  (ref) => ref.watch(
    taxiProvider.select((s) => s.pickup.isNotEmpty && s.destination.isNotEmpty),
  ),
);

final taxiIsLoadingProvider = Provider<bool>(
  (ref) => ref.watch(taxiProvider.select((s) => s.isLoading)),
);

