import 'package:equatable/equatable.dart';

/// Parameters required to book a car rental offer.
/// API body: { "offer_id", "provider_slug", "name", "phone" }
class BookCarRentalParams extends Equatable {
  final String offerId;
  final String name;
  final String phone;
  final String providerSlug;

  const BookCarRentalParams({
    required this.offerId,
    required this.name,
    required this.phone,
    required this.providerSlug,
  });

  Map<String, dynamic> toJson() => {
        'offer_id': offerId,
        'provider_slug': providerSlug,
        'name': name,
        'phone': phone,
      };

  @override
  List<Object?> get props => [offerId, name, phone, providerSlug];
}

