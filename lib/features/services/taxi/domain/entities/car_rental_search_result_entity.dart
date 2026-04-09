import 'package:equatable/equatable.dart';
import 'car_rental_offer_entity.dart';

/// Top-level response entity for car rental search results.
class CarRentalSearchResultEntity extends Equatable {
  final bool status;
  final int count;
  final CarRentalOfferEntity? cheapest;
  final List<CarRentalOfferEntity> offers;

  const CarRentalSearchResultEntity({
    this.status = false,
    this.count = 0,
    this.cheapest,
    this.offers = const [],
  });

  @override
  List<Object?> get props => [status, count, cheapest, offers];
}

