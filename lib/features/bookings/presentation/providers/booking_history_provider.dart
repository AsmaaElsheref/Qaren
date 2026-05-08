import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/booking_history_remote_datasource.dart';
import '../../data/datasources/booking_history_remote_datasource_impl.dart';
import '../../data/repositories/booking_history_repository_impl.dart';
import '../../domain/entities/booking_service_type.dart';
import '../../domain/entities/booking_status_filter.dart';
import '../../domain/repositories/booking_history_repository.dart';
import '../../domain/usecases/get_booking_history_usecase.dart';
import 'booking_history_state.dart';

final bookingHistoryRemoteDataSourceProvider = Provider<BookingHistoryRemoteDataSource>(
  (ref) => const BookingHistoryRemoteDataSourceImpl(),
);

final bookingHistoryRepositoryProvider = Provider<BookingHistoryRepository>(
  (ref) => BookingHistoryRepositoryImpl(
    ref.watch(bookingHistoryRemoteDataSourceProvider),
  ),
);

final getBookingHistoryUseCaseProvider = Provider<GetBookingHistoryUseCase>(
  (ref) => GetBookingHistoryUseCase(ref.watch(bookingHistoryRepositoryProvider)),
);

final bookingHistoryProvider = StateNotifierProvider<BookingHistoryNotifier, BookingHistoryState>(
  (ref) => BookingHistoryNotifier(
    getBookingHistoryUseCase: ref.watch(getBookingHistoryUseCaseProvider),
  )..loadInitial(),
);

class BookingHistoryNotifier extends StateNotifier<BookingHistoryState> {
  final GetBookingHistoryUseCase getBookingHistoryUseCase;

  BookingHistoryNotifier({required this.getBookingHistoryUseCase})
      : super(const BookingHistoryState());

  Future<void> loadInitial() async {
    state = state.copyWith(
      isInitialLoading: true,
      isLoadingMore: false,
      isRefreshing: false,
      bookings: const [],
      currentPage: 1,
      hasMore: false,
      clearError: true,
    );
    await fetchPage(page: 1, append: false);
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, clearError: true);
    await fetchPage(page: 1, append: false);
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isInitialLoading) return;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    await fetchPage(page: state.currentPage + 1, append: true);
  }

  Future<void> changeServiceType(BookingServiceType serviceType) async {
    if (serviceType == state.selectedServiceType) return;
    state = state.copyWith(selectedServiceType: serviceType, clearError: true);
    await loadInitial();
  }

  Future<void> changeStatus(BookingStatusFilter status) async {
    if (status == state.selectedStatus) return;
    state = state.copyWith(selectedStatus: status, clearError: true);
    await loadInitial();
  }

  Future<void> fetchPage({required int page, required bool append}) async {
    final result = await getBookingHistoryUseCase(
      page: page,
      serviceType: state.selectedServiceType,
      status: state.selectedStatus,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        state = state.copyWith(
          isInitialLoading: false,
          isLoadingMore: false,
          isRefreshing: false,
          errorMessage: failure.message,
        );
      },
      (pagination) {
        final nextBookings = append
            ? [...state.bookings, ...pagination.bookings]
            : pagination.bookings;

        state = state.copyWith(
          bookings: nextBookings,
          currentPage: pagination.currentPage,
          hasMore: pagination.hasMore,
          isInitialLoading: false,
          isLoadingMore: false,
          isRefreshing: false,
          clearError: true,
        );
      },
    );
  }
}
