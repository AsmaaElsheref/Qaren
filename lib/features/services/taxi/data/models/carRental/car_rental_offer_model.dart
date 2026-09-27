import '../../../domain/entities/car_rental_offer_entity.dart';
import 'provider_data_model.dart';

class CarRentalOfferModel extends CarRentalOfferEntity {
  const CarRentalOfferModel({
    super.carId,
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
      carId: _asString(json['id'] ?? json['car_id']),
      offerId: _asString(json['fare_id'] ?? json['offer_id']),
      providerId: _asString(json['providerId'] ?? json['provider_id']),
      providerName: _asString(json['providerName'] ?? json['provider_name']),
      providerSlug: _asString(
        json['providerSlug'] ??
            json['provider_slug'] ??
            json['providerName'] ??
            json['providerId'],
      ),
      carName: _asString(json['name'] ?? json['car_name']),
      carType: _asString(json['type'] ?? json['car_type']),
      carImage: _asString(json['image'] ?? json['car_image']),
      price: _parseDouble(json['price']),
      currency: json['currency'] as String?,
      originalCurrency: json['original_currency'] as String?,
      originalPrice: _parseDouble(json['original_price']),
      priceEgp: _parseDouble(json['price_egp']),
      totalPrice: _parseDouble(json['total_price']),
      seats: _parseInt(json['capacity'] ?? json['seats']),
      bags: _parseInt(json['bags']),
      available: json['available'] != false,
      distance: _asString(json['distance'] ?? json['distance_km']),
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
