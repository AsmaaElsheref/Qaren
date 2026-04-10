import 'package:equatable/equatable.dart';
import '../../../domain/entities/booking_result_entity.dart';

enum BookingStatus { initial, loading, success, failure }

class BookingState extends Equatable {
  final BookingStatus status;
  final BookingResultEntity? result;
  final String? errorMessage;

  const BookingState({
    this.status = BookingStatus.initial,
    this.result,
    this.errorMessage,
  });

  BookingState copyWith({
    BookingStatus? status,
    BookingResultEntity? result,
    String? errorMessage,
  }) =>
      BookingState(
        status: status ?? this.status,
        result: result ?? this.result,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, result, errorMessage];
}