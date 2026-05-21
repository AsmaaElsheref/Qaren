import 'package:equatable/equatable.dart';
import 'car_rental_offer_entity.dart';
import 'parsed_ai_parameters_entity.dart';

/// Top-level response entity for car rental search results.
class CarRentalSearchResultEntity extends Equatable {
  final bool status;
  final int count;
  final CarRentalOfferEntity? cheapest;
  final List<CarRentalOfferEntity> offers;

  /// Only populated when the response came from the AI search endpoint.
  final ParsedAiParametersEntity? parsedParameters;

  const CarRentalSearchResultEntity({
    this.status = false,
    this.count = 0,
    this.cheapest,
    this.offers = const [],
    this.parsedParameters,
  });

  @override
  List<Object?> get props =>
      [status, count, cheapest, offers, parsedParameters];
}
