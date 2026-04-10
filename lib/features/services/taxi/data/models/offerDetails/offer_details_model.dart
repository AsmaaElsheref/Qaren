import '../../../domain/entities/offer_details_entity.dart';

class OfferDetailsModel extends OfferDetailsEntity {
  const OfferDetailsModel({
    super.offerId, super.name, super.type, super.category,
    super.pricePerDay, super.totalPrice, super.currency,
    super.specs, super.features, super.images,
    super.insurance, super.terms, super.location,
    super.supplier, super.provider,
  });

  factory OfferDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return OfferDetailsModel(
      offerId: data['offer_id'] as String?,
      name: data['name'] as String?,
      type: data['type'] as String?,
      category: data['category'] as String?,
      pricePerDay: _d(data['price_per_day']),
      totalPrice: _d(data['total_price']),
      currency: data['currency'] as String?,
      specs: _parseSpecs(data['specs']),
      features: _stringList(data['features']),
      images: _stringList(data['images']),
      insurance: _parseInsurance(data['insurance']),
      terms: _parseTerms(data['terms']),
      location: _parseLocation(data['location']),
      supplier: _parseSupplier(data['supplier']),
      provider: _parseProvider(data['provider']),
    );
  }

  static OfferSpecsEntity _parseSpecs(dynamic raw) {
    if (raw is! Map<String, dynamic>) return const OfferSpecsEntity();
    final bags = raw['bags'] as Map<String, dynamic>? ?? {};
    return OfferSpecsEntity(
      seats: _i(raw['seats']), doors: _i(raw['doors']),
      largeBags: _i(bags['large']), smallBags: _i(bags['small']),
      transmission: raw['transmission'] as String?,
      fuelType: raw['fuel_type'] as String?,
      airConditioning: raw['air_conditioning'] == true,
    );
  }

  static OfferInsuranceEntity _parseInsurance(dynamic raw) {
    if (raw is! Map<String, dynamic>) return const OfferInsuranceEntity();
    return OfferInsuranceEntity(
      type: raw['type'] as String?,
      deductible: _d(raw['deductible']),
      deductibleCurrency: raw['deductible_currency'] as String?,
      includesCdw: raw['includes_cdw'] == true,
      includesTp: raw['includes_tp'] == true,
    );
  }

  static OfferTermsEntity _parseTerms(dynamic raw) {
    if (raw is! Map<String, dynamic>) return const OfferTermsEntity();
    return OfferTermsEntity(
      minimumAge: _i(raw['minimum_age']),
      depositRequired: raw['deposit_required'] == true,
      depositAmount: _d(raw['deposit_amount']),
      freeCancellationHours: _i(raw['free_cancellation_hours']),
      mileageLimit: raw['mileage_limit'] as String?,
    );
  }

  static OfferLocationEntity _parseLocation(dynamic raw) {
    if (raw is! Map<String, dynamic>) return const OfferLocationEntity();
    return OfferLocationEntity(
      pickup: _point(raw['pickup']),
      dropoff: _point(raw['dropoff']),
    );
  }

  static OfferLocationPointEntity _point(dynamic raw) {
    if (raw is! Map<String, dynamic>) return const OfferLocationPointEntity();
    return OfferLocationPointEntity(
      address: raw['address'] as String?,
      lat: _d(raw['lat']), lng: _d(raw['lng']),
      instructions: raw['instructions'] as String?,
    );
  }

  static OfferSupplierEntity _parseSupplier(dynamic raw) {
    if (raw is! Map<String, dynamic>) return const OfferSupplierEntity();
    return OfferSupplierEntity(
      name: raw['name'] as String?, rating: _d(raw['rating']),
      reviewsCount: _i(raw['reviews_count']),
      badge: raw['badge'] as String?,
    );
  }

  static OfferProviderEntity _parseProvider(dynamic raw) {
    if (raw is! Map<String, dynamic>) return const OfferProviderEntity();
    return OfferProviderEntity(
      name: raw['name'] as String?, slug: raw['slug'] as String?,
    );
  }

  static double? _d(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  static int? _i(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  static List<String> _stringList(dynamic v) {
    if (v is! List) return const [];
    return v.whereType<String>().toList();
  }
}

