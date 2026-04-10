import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/utils/print/custom_print.dart';

import '../../../data/datasources/car_rental_remote_datasource.dart';
import '../../../data/repositories/car_rental_repository_impl.dart';
import '../../../domain/entities/book_car_rental_params.dart';
import '../../../domain/repositories/car_rental_repository.dart';
import '../../../domain/usecases/book_car_rental_usecase.dart';
import 'booking_state.dart';

// ── Data layer providers (private) ──────────────────────────────────────────

final _remoteDataSourceProvider = Provider<CarRentalRemoteDataSource>(
  (ref) => const CarRentalRemoteDataSourceImpl(),
);

final _repositoryProvider = Provider<CarRentalRepository>(
  (ref) => CarRentalRepositoryImpl(ref.watch(_remoteDataSourceProvider)),
);

final _useCaseProvider = Provider<BookCarRentalUseCase>(
  (ref) => BookCarRentalUseCase(ref.watch(_repositoryProvider)),
);

// ── Notifier ─────────────────────────────────────────────────────────────────

class BookingNotifier extends Notifier<BookingState> {
  @override
  BookingState build() => const BookingState();

  /// Resets the state back to initial (e.g. when leaving the screen).
  void reset() => state = const BookingState();

  Future<void> book(BookCarRentalParams params) async {
    customPrint(params);
    customPrint(params.offerId);
    customPrint(params.name);
    customPrint(params.providerSlug);
    customPrint(params.phone);
    state = state.copyWith(
      status: BookingStatus.loading,
      errorMessage: null,
    );

    final useCase = ref.read(_useCaseProvider);
    final result = await useCase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: BookingStatus.failure,
        errorMessage: failure.message,
      ),
      (data) => state = state.copyWith(
        status: BookingStatus.success,
        result: data,
      ),
    );
  }
}

// ── Providers ────────────────────────────────────────────────────────────────

final bookingProvider = NotifierProvider<BookingNotifier, BookingState>(
  BookingNotifier.new,
);

/// Granular — status only (minimises rebuild scope).
final bookingStatusProvider = Provider<BookingStatus>(
  (ref) => ref.watch(bookingProvider.select((s) => s.status)),
);

