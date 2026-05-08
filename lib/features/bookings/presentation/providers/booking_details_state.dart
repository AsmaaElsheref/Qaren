import 'package:equatable/equatable.dart';

import '../../domain/entities/booking_details_entity.dart';

class BookingDetailsState extends Equatable {
  final bool isLoading;
  final BookingDetailsEntity? details;
  final String? errorMessage;

  const BookingDetailsState({
    this.isLoading = false,
    this.details,
    this.errorMessage,
  });

  BookingDetailsState copyWith({
    bool? isLoading,
    BookingDetailsEntity? details,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BookingDetailsState(
      isLoading: isLoading ?? this.isLoading,
      details: details ?? this.details,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, details, errorMessage];
}

