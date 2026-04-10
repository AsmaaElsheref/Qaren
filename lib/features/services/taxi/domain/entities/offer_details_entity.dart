import 'package:equatable/equatable.dart';

/// Top-level entity for a single car rental offer's full details.
class OfferDetailsEntity extends Equatable {
  final String? offerId;
  final String? name;
  final String? type;
  final String? category;
  final double? pricePerDay;
  final double? totalPrice;
  final String? currency;
  final OfferSpecsEntity specs;
  final List<String> features;
  final List<String> images;
  final OfferInsuranceEntity insurance;
  final OfferTermsEntity terms;
  final OfferLocationEntity location;
  final OfferSupplierEntity supplier;
  final OfferProviderEntity provider;

  const OfferDetailsEntity({
    this.offerId,
    this.name,
    this.type,
    this.category,
    this.pricePerDay,
    this.totalPrice,
    this.currency,
    this.specs = const OfferSpecsEntity(),
    this.features = const [],
    this.images = const [],
    this.insurance = const OfferInsuranceEntity(),
    this.terms = const OfferTermsEntity(),
    this.location = const OfferLocationEntity(),
    this.supplier = const OfferSupplierEntity(),
    this.provider = const OfferProviderEntity(),
  });

  @override
  List<Object?> get props => [
        offerId, name, type, category, pricePerDay, totalPrice, currency,
        specs, features, images, insurance, terms, location, supplier, provider,
      ];
}

// ── Specs ──────────────────────────────────────────────────────────────────────

class OfferSpecsEntity extends Equatable {
  final int? seats;
  final int? doors;
  final int? largeBags;
  final int? smallBags;
  final String? transmission;
  final String? fuelType;
  final bool airConditioning;

  const OfferSpecsEntity({
    this.seats,
    this.doors,
    this.largeBags,
    this.smallBags,
    this.transmission,
    this.fuelType,
    this.airConditioning = false,
  });

  @override
  List<Object?> get props => [
        seats, doors, largeBags, smallBags,
        transmission, fuelType, airConditioning,
      ];
}

// ── Insurance ─────────────────────────────────────────────────────────────────

class OfferInsuranceEntity extends Equatable {
  final String? type;
  final double? deductible;
  final String? deductibleCurrency;
  final bool includesCdw;
  final bool includesTp;

  const OfferInsuranceEntity({
    this.type,
    this.deductible,
    this.deductibleCurrency,
    this.includesCdw = false,
    this.includesTp = false,
  });

  @override
  List<Object?> get props => [
        type, deductible, deductibleCurrency, includesCdw, includesTp,
      ];
}

// ── Terms ─────────────────────────────────────────────────────────────────────

class OfferTermsEntity extends Equatable {
  final int? minimumAge;
  final bool depositRequired;
  final double? depositAmount;
  final int? freeCancellationHours;
  final String? mileageLimit;

  const OfferTermsEntity({
    this.minimumAge,
    this.depositRequired = false,
    this.depositAmount,
    this.freeCancellationHours,
    this.mileageLimit,
  });

  @override
  List<Object?> get props => [
        minimumAge, depositRequired, depositAmount,
        freeCancellationHours, mileageLimit,
      ];
}

// ── Location ──────────────────────────────────────────────────────────────────

class OfferLocationEntity extends Equatable {
  final OfferLocationPointEntity pickup;
  final OfferLocationPointEntity dropoff;

  const OfferLocationEntity({
    this.pickup = const OfferLocationPointEntity(),
    this.dropoff = const OfferLocationPointEntity(),
  });

  @override
  List<Object?> get props => [pickup, dropoff];
}

class OfferLocationPointEntity extends Equatable {
  final String? address;
  final double? lat;
  final double? lng;
  final String? instructions;

  const OfferLocationPointEntity({
    this.address,
    this.lat,
    this.lng,
    this.instructions,
  });

  @override
  List<Object?> get props => [address, lat, lng, instructions];
}

// ── Supplier ──────────────────────────────────────────────────────────────────

class OfferSupplierEntity extends Equatable {
  final String? name;
  final double? rating;
  final int? reviewsCount;
  final String? badge;

  const OfferSupplierEntity({
    this.name,
    this.rating,
    this.reviewsCount,
    this.badge,
  });

  @override
  List<Object?> get props => [name, rating, reviewsCount, badge];
}

// ── Provider ──────────────────────────────────────────────────────────────────

class OfferProviderEntity extends Equatable {
  final String? name;
  final String? slug;

  const OfferProviderEntity({this.name, this.slug});

  @override
  List<Object?> get props => [name, slug];
}

