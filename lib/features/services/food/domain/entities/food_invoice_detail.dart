import 'package:equatable/equatable.dart';

import 'invoice_product.dart';

/// Full invoice detail returned by
/// GET /api/food-products/compare/{partnerId}?product_ids[]=...&user_lat=...&user_lng=...
class FoodInvoiceDetail extends Equatable {
  const FoodInvoiceDetail({
    required this.partnerId,
    required this.partnerName,
    this.partnerLogo,
    this.partnerPhone,
    this.partnerEmail,
    this.partnerWebsite,
    this.isVerified = false,
    this.rating,
    this.ratingCount,
    this.deliveryFee,
    this.distanceKm,
    required this.matchedCount,
    required this.productsSubtotal,
    required this.grandTotal,
    required this.currency,
    required this.products,
  });

  final int partnerId;
  final String partnerName;
  final String? partnerLogo;
  final String? partnerPhone;
  final String? partnerEmail;
  final String? partnerWebsite;
  final bool isVerified;
  final double? rating;
  final String? ratingCount;
  final double? deliveryFee;
  final double? distanceKm;
  final int matchedCount;
  final double productsSubtotal;
  final double grandTotal;
  final String currency;
  final List<InvoiceProduct> products;

  @override
  List<Object?> get props => [partnerId];
}

