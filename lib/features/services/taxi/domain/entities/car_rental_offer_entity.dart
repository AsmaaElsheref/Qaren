import 'package:equatable/equatable.dart';
import 'provider_data_entity.dart';

/// Represents a single car rental offer from a provider.
class CarRentalOfferEntity extends Equatable {
  final String? offerId;
  final String? providerId;
  final String? providerName;
  final String? providerSlug;
  final String? carName;
  final String? carType;
  final String? carImage;
  final double? price;
  final String? currency;
  final String? originalCurrency;
  final double? originalPrice;
  final double? priceEgp;
  final double? totalPrice;
  final int? seats;
  final int? bags;
  final bool available;
  final String? distance;
  final ProviderDataEntity providerData;

  const CarRentalOfferEntity({
    this.offerId,
    this.providerId,
    this.providerName,
    this.providerSlug,
    this.carName,
    this.carType,
    this.carImage,
    this.price,
    this.currency,
    this.originalCurrency,
    this.originalPrice,
    this.priceEgp,
    this.totalPrice,
    this.seats,
    this.bags,
    this.available = true,
    this.distance,
    this.providerData = const ProviderDataEntity(),
  });

  @override
  List<Object?> get props => [
        offerId,
        providerId,
        providerName,
        providerSlug,
        carName,
        carType,
        carImage,
        price,
        currency,
        originalCurrency,
        originalPrice,
        priceEgp,
        totalPrice,
        seats,
        bags,
        available,
        distance,
        providerData,
      ];
}

