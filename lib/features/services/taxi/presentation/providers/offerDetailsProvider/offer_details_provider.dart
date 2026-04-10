import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/car_rental_remote_datasource.dart';
import '../../../data/repositories/car_rental_repository_impl.dart';
import '../../../domain/repositories/car_rental_repository.dart';
import '../../../domain/usecases/get_offer_details_usecase.dart';
import 'offer_details_state.dart';

// ── Data layer providers (private) ──────────────────────────────────────────

final _remoteDataSourceProvider = Provider<CarRentalRemoteDataSource>(
  (ref) => const CarRentalRemoteDataSourceImpl(),
);

final _repositoryProvider = Provider<CarRentalRepository>(
  (ref) => CarRentalRepositoryImpl(ref.watch(_remoteDataSourceProvider)),
);

final _useCaseProvider = Provider<GetOfferDetailsUseCase>(
  (ref) => GetOfferDetailsUseCase(ref.watch(_repositoryProvider)),
);

// ── Notifier ─────────────────────────────────────────────────────────────────

class OfferDetailsNotifier extends Notifier<OfferDetailsState> {
  @override
  OfferDetailsState build() => const OfferDetailsState();

  Future<void> fetch(String offerId) async {
    state = state.copyWith(
      status: OfferDetailsStatus.loading,
      errorMessage: null,
    );

    final useCase = ref.read(_useCaseProvider);
    final result = await useCase(offerId);

    result.fold(
      (failure) => state = state.copyWith(
        status: OfferDetailsStatus.failure,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        status: OfferDetailsStatus.success,
        details: data,
      ),
    );
  }
}

// ── Providers ────────────────────────────────────────────────────────────────

final offerDetailsProvider =
    NotifierProvider<OfferDetailsNotifier, OfferDetailsState>(
  OfferDetailsNotifier.new,
);

/// Granular — status only.
final offerDetailsStatusProvider = Provider<OfferDetailsStatus>(
  (ref) => ref.watch(
    offerDetailsProvider.select((s) => s.status),
  ),
);

