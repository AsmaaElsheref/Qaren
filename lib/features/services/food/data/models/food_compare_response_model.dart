import '../../domain/entities/food_product_preview.dart';
import '../../domain/entities/food_provider_model.dart';

/// Parses the full compare API response and returns
/// the list of [FoodProviderModel] with smart-pick flags set.
class FoodCompareResponseModel {
  FoodCompareResponseModel._();

  static List<FoodProviderModel> fromJson(Map<String, dynamic> json) {
    final smartPicks = json['smart_picks'] as Map<String, dynamic>? ?? {};
    final recommendedId = smartPicks['recommended_partner_id'];
    final cheapestId    = smartPicks['cheapest_partner_id'];
    final fastestId     = smartPicks['fastest_partner_id'];

    final rawPartners = json['partners'] as List<dynamic>? ?? [];
    return rawPartners
        .cast<Map<String, dynamic>>()
        .map((p) => _parsePartner(p, recommendedId, cheapestId, fastestId))
        .toList();
  }

  static FoodProviderModel _parsePartner(
    Map<String, dynamic> raw,
    dynamic recommendedId,
    dynamic cheapestId,
    dynamic fastestId,
  ) {
    final partnerId = raw['partner_id'];
    final previews  = (raw['products_preview'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>()
        .map(_parsePreview)
        .toList();

    final isRecommended = partnerId == recommendedId;
    final isCheapest    = partnerId == cheapestId;
    final isFastest     = partnerId == fastestId;

    String tag = '';
    if (isRecommended) tag = 'الأنسب';
    else if (isCheapest) tag = 'الأرخص';
    else if (isFastest)  tag = 'الأسرع';

    return FoodProviderModel(
      id:             partnerId?.toString() ?? '',
      name:           raw['name'] as String? ?? '',
      logoUrl:        raw['logo'] as String?,
      isVerified:     raw['is_verified'] as bool? ?? false,
      rating:         _toDouble(raw['rating']),
      ratingCount:    raw['rating_count']?.toString(),
      distanceKm:     _toDouble(raw['distance_km']),
      deliveryFee:    _toDouble(raw['delivery_fee']),
      currency:       raw['currency'] as String? ?? 'SAR',
      price:          _toDouble(raw['starting_price']) ?? 0,
      matchedCount:   raw['matched_count'] as int? ?? 0,
      totalRequested: raw['total_requested'] as int? ?? 0,
      productsPreview: previews,
      isBestValue:    isRecommended,
      isCheapest:     isCheapest,
      isFastest:      isFastest,
      tag:            tag,
    );
  }

  static FoodProductPreview _parsePreview(Map<String, dynamic> raw) {
    return FoodProductPreview(
      id:          raw['id'] as int? ?? 0,
      name:        raw['name'] as String? ?? '',
      price:       _toDouble(raw['price']) ?? 0,
      thumbnail:   raw['thumbnail'] as String? ?? '',
      rating:      _toDouble(raw['rating']),
      prepTimeMin: int.tryParse(raw['prep_time_min']?.toString() ?? ''),
    );
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString());
  }
}

