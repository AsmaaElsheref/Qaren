import '../../domain/entities/food_invoice_detail.dart';
import '../../domain/entities/invoice_product.dart';

/// Parses the single-partner invoice detail response:
/// GET /api/food-products/compare/{partnerId}?product_ids[]=...
class FoodInvoiceDetailModel {
  FoodInvoiceDetailModel._();

  static FoodInvoiceDetail fromJson(Map<String, dynamic> json) {
    final partner  = json['partner']  as Map<String, dynamic>? ?? {};
    final delivery = partner['delivery'] as Map<String, dynamic>? ?? {};

    final rawProducts = json['products'] as List<dynamic>? ?? [];
    final products = rawProducts
        .cast<Map<String, dynamic>>()
        .map(_parseProduct)
        .toList();

    return FoodInvoiceDetail(
      partnerId:        (partner['id'] as num?)?.toInt() ?? 0,
      partnerName:      partner['name'] as String? ?? '',
      partnerLogo:      partner['logo'] as String?,
      partnerPhone:     partner['phone'] as String?,
      partnerEmail:     partner['email'] as String?,
      partnerWebsite:   partner['website'] as String?,
      isVerified:       partner['is_verified'] as bool? ?? false,
      rating:           _toDouble(partner['rating']),
      ratingCount:      partner['rating_count']?.toString(),
      deliveryFee:      _toDouble(json['delivery_fee']),
      distanceKm:       _toDouble(delivery['distance_km']),
      matchedCount:     (json['matched_count'] as num?)?.toInt() ?? 0,
      productsSubtotal: _toDouble(json['products_subtotal']) ?? 0,
      grandTotal:       _toDouble(json['grand_total']) ?? 0,
      currency:         json['currency'] as String? ?? 'SAR',
      products:         products,
    );
  }

  static InvoiceProduct _parseProduct(Map<String, dynamic> raw) {
    return InvoiceProduct(
      id:          (raw['id'] as num?)?.toInt() ?? 0,
      name:        raw['name'] as String? ?? '',
      price:       _toDouble(raw['price']) ?? 0,
      thumbnail:   raw['thumbnail'] as String? ?? '',
      calories:    raw['calories']?.toString(),
      prepTimeMin: raw['prep_time_min']?.toString(),
      rating:      raw['rating']?.toString(),
    );
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString());
  }
}

