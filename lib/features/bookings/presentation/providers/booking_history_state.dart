import 'package:equatable/equatable.dart';

import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/booking_service_type.dart';
import '../../domain/entities/booking_status_filter.dart';

class BookingHistoryState extends Equatable {
  final BookingServiceType selectedServiceType;
  final BookingStatusFilter selectedStatus;
  final List<BookingEntity> bookings;
  final int currentPage;
  final bool hasMore;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? errorMessage;

  const BookingHistoryState({
    this.selectedServiceType = BookingServiceType.all,
    this.selectedStatus = BookingStatusFilter.all,
    this.bookings = const [],
    this.currentPage = 1,
    this.hasMore = false,
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  bool get isEmpty => !isInitialLoading && bookings.isEmpty && errorMessage == null;

  BookingHistoryState copyWith({
    BookingServiceType? selectedServiceType,
    BookingStatusFilter? selectedStatus,
    List<BookingEntity>? bookings,
    int? currentPage,
    bool? hasMore,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BookingHistoryState(
      selectedServiceType: selectedServiceType ?? this.selectedServiceType,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      bookings: bookings ?? this.bookings,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        selectedServiceType,
        selectedStatus,
        bookings,
        currentPage,
        hasMore,
        isInitialLoading,
        isLoadingMore,
        isRefreshing,
        errorMessage,
      ];
}

