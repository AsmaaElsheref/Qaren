import '../../../domain/entities/car_rental_offer_entity.dart';
import 'provider_data_model.dart';

class CarRentalOfferModel extends CarRentalOfferEntity {
  const CarRentalOfferModel({
    super.offerId,
    super.providerId,
    super.providerName,
    super.providerSlug,
    super.carName,
    super.carType,
    super.carImage,
    super.price,
    super.currency,
    super.originalCurrency,
    super.originalPrice,
    super.priceEgp,
    super.totalPrice,
    super.seats,
    super.bags,
    super.available,
    super.distance,
    super.providerData,
  });

  factory CarRentalOfferModel.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final providerDataJson =
        meta['provider_data'] as Map<String, dynamic>? ?? {};

    return CarRentalOfferModel(
      offerId: _asString(json['offer_id']),
      providerId: _asString(json['provider_id']),
      providerName: json['provider_name'] as String?,
      providerSlug: json['provider_slug'] as String?,
      carName: json['car_name'] as String?,
      carType: json['car_type'] as String?,
      carImage: json['car_image'] as String?,
      price: _parseDouble(json['price']),
      currency: json['currency'] as String?,
      originalCurrency: json['original_currency'] as String?,
      originalPrice: _parseDouble(json['original_price']),
      priceEgp: _parseDouble(json['price_egp']),
      totalPrice: _parseDouble(json['total_price']),
      seats: _parseInt(json['seats']),
      bags: _parseInt(json['bags']),
      available: json['available'] != false,
      distance: _asString(json['distance']),
      providerData: ProviderDataModel.fromJson(providerDataJson),
    );
  }

  // ── Defensive parsers ────────────────────────────────────────────────────

  static String? _asString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

