import 'package:equatable/equatable.dart';

/// Entity representing the result of a successful car rental booking.
class BookingResultEntity extends Equatable {
  final int? id;
  final int? userId;
  final String? serviceType;
  final String? providerSlug;
  final String? bookingReference;
  final String? status;
  final String? sessionId;
  final BookingDetailsEntity bookingDetails;
  final BookingProviderResponseEntity providerResponse;
  final String? createdAt;
  final String? updatedAt;

  const BookingResultEntity({
    this.id,
    this.userId,
    this.serviceType,
    this.providerSlug,
    this.bookingReference,
    this.status,
    this.sessionId,
    this.bookingDetails = const BookingDetailsEntity(),
    this.providerResponse = const BookingProviderResponseEntity(),
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id, userId, serviceType, providerSlug, bookingReference,
        status, sessionId, bookingDetails, providerResponse,
        createdAt, updatedAt,
      ];
}

/// Nested booking details (offer_id, customer info).
class BookingDetailsEntity extends Equatable {
  final String? offerId;
  final String? customerName;
  final String? customerPhone;

  const BookingDetailsEntity({
    this.offerId,
    this.customerName,
    this.customerPhone,
  });

  @override
  List<Object?> get props => [offerId, customerName, customerPhone];
}

/// Nested provider response after booking.
class BookingProviderResponseEntity extends Equatable {
  final String? message;
  final String? simulatedProvider;

  const BookingProviderResponseEntity({
    this.message,
    this.simulatedProvider,
  });

  @override
  List<Object?> get props => [message, simulatedProvider];
}

