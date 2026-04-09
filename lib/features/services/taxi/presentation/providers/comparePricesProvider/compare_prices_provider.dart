import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/utils/print/custom_print.dart';

import '../../../data/datasources/car_rental_remote_datasource.dart';
import '../../../data/models/comparePrices/compare_prices_model.dart';
import '../../../data/repositories/car_rental_repository_impl.dart';
import '../../../domain/entities/car_rental_offer_entity.dart';
import '../../../domain/entities/car_rental_search_params.dart';
import '../../../domain/repositories/car_rental_repository.dart';
import '../../../domain/usecases/search_car_rental_usecase.dart';
import 'compare_prices_state.dart';

// ── Data layer providers (private) ──────────────────────────────────────────

final _remoteDataSourceProvider = Provider<CarRentalRemoteDataSource>(
  (ref) => const CarRentalRemoteDataSourceImpl(),
);

final _repositoryProvider = Provider<CarRentalRepository>(
  (ref) => CarRentalRepositoryImpl(ref.watch(_remoteDataSourceProvider)),
);

final _searchUseCaseProvider = Provider<SearchCarRentalUseCase>(
  (ref) => SearchCarRentalUseCase(ref.watch(_repositoryProvider)),
);

// ── Notifier ─────────────────────────────────────────────────────────────────

class ComparePricesNotifier extends Notifier<ComparePricesState> {
  @override
  ComparePricesState build() => const ComparePricesState();

  void setSort(CompareSortType sort) =>
      state = state.copyWith(sortType: sort);

  /// Calls the search API and maps results into [PriceResult].
  Future<void> search(CarRentalSearchParams params) async {
    state = state.copyWith(
      status: ComparePricesStatus.loading,
      errorMessage: null,
    );

    final useCase = ref.read(_searchUseCaseProvider);
    final result = await useCase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: ComparePricesStatus.failure,
        errorMessage: failure.message,
      ),
      (data) {
        if (data.offers.isEmpty) {
          state = state.copyWith(
            status: ComparePricesStatus.empty,
            results: [],
          );
          return;
        }

        final cheapestId = data.cheapest?.offerId;
        final mapped = data.offers.map((offer) {
          return _mapOfferToPriceResult(
            offer,
            isBestValue: offer.offerId == cheapestId,
          );
        }).toList();

        customPrint('Result Data : ${mapped[0]}');
        state = state.copyWith(
          status: ComparePricesStatus.success,
          results: mapped,
        );
      },
    );
  }

  /// Maps an API [CarRentalOfferEntity] to the UI [PriceResult].
  PriceResult _mapOfferToPriceResult(
    CarRentalOfferEntity offer, {
    bool isBestValue = false,
  }) {
    return PriceResult(
      id: offer.offerId ?? '',
      appName: offer.providerName ?? offer.carName ?? 'غير معروف',
      rideType: offer.carType ?? '',
      price: offer.price ?? 0.0,
      currency: offer.currency ?? 'SAR',
      totalPrice: offer.totalPrice,
      rating: offer.providerData.rating ?? 0.0,
      distance: offer.distance,
      iconBgColor: _providerColor(offer.providerSlug),
      iconColor: const Color(0xFFFFFFFF),
      icon: offer.carImage??'',
      isBestValue: isBestValue,
    );
  }

  Color _providerColor(String? slug) {
    if (slug == null) return const Color(0xFF424242);
    final lower = slug.toLowerCase();
    if (lower.contains('uber')) return const Color(0xFF1A1A1A);
    if (lower.contains('careem')) return const Color(0xFF4CAF50);
    if (lower.contains('bolt')) return const Color(0xFF34D186);
    if (lower.contains('yelo')) return const Color(0xFFFFB300);
    return const Color(0xFF424242);
  }
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

/// Granular — the status for loading/error/empty/success checks.
final comparePricesStatusProvider = Provider<ComparePricesStatus>(
  (ref) => ref.watch(
    comparePricesProvider.select((s) => s.status),
  ),
);

