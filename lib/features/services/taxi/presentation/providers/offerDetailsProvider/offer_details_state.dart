import 'package:equatable/equatable.dart';
import '../../../domain/entities/offer_details_entity.dart';

enum OfferDetailsStatus { initial, loading, success, failure }

class OfferDetailsState extends Equatable {
  final OfferDetailsStatus status;
  final OfferDetailsEntity? details;
  final String? errorMessage;

  const OfferDetailsState({
    this.status = OfferDetailsStatus.initial,
    this.details,
    this.errorMessage,
  });

  OfferDetailsState copyWith({
    OfferDetailsStatus? status,
    OfferDetailsEntity? details,
    String? errorMessage,
  }) =>
      OfferDetailsState(
        status: status ?? this.status,
        details: details ?? this.details,
        errorMessage: errorMessage,
      );

  @override
  List<Object?> get props => [status, details, errorMessage];
}

