import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_booking_details_usecase.dart';
import 'booking_details_state.dart';
import 'booking_history_provider.dart';

final getBookingDetailsUseCaseProvider = Provider<GetBookingDetailsUseCase>(
  (ref) => GetBookingDetailsUseCase(ref.watch(bookingHistoryRepositoryProvider)),
);

final bookingDetailsProvider = StateNotifierProvider.autoDispose
    .family<BookingDetailsNotifier, BookingDetailsState, int>(
  (ref, id) => BookingDetailsNotifier(
    id: id,
    getBookingDetailsUseCase: ref.watch(getBookingDetailsUseCaseProvider),
  )..load(),
);

class BookingDetailsNotifier extends StateNotifier<BookingDetailsState> {
  final int id;
  final GetBookingDetailsUseCase getBookingDetailsUseCase;

  BookingDetailsNotifier({
    required this.id,
    required this.getBookingDetailsUseCase,
  }) : super(const BookingDetailsState(isLoading: true));

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await getBookingDetailsUseCase(id: id);

    if (!mounted) return;

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (details) => state = state.copyWith(
        isLoading: false,
        details: details,
        clearError: true,
      ),
    );
  }
}

