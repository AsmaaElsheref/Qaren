import '../../../domain/entities/car_rental_search_result_entity.dart';
import '../../../domain/entities/parsed_ai_parameters_entity.dart';
import 'car_rental_offer_model.dart';

class CarRentalSearchResultModel extends CarRentalSearchResultEntity {
  const CarRentalSearchResultModel({
    super.status,
    super.count,
    super.cheapest,
    super.offers,
    super.parsedParameters,
  });

  factory CarRentalSearchResultModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final dataList = rawData is Map<String, dynamic>
        ? rawData['cars'] as List<dynamic>? ?? const []
        : rawData as List<dynamic>? ?? const [];

    final offers = dataList
        .whereType<Map<String, dynamic>>()
        .map(CarRentalOfferModel.fromJson)
        .toList();

    final cheapestJson = json['cheapest'] as Map<String, dynamic>?;
    final cheapest = cheapestJson != null
        ? CarRentalOfferModel.fromJson(cheapestJson)
        : _findCheapest(offers);
    final meta = rawData is Map<String, dynamic>
        ? rawData['meta'] as Map<String, dynamic>?
        : null;
    final total = (meta?['total'] as num?)?.toInt();

    // ── AI assistant block (optional — only present in ai-search response) ──
    final aiAssistant =
        (rawData is Map<String, dynamic>
            ? rawData['ai_assistant'] as Map<String, dynamic>?
            : null) ??
        json['ai_assistant'] as Map<String, dynamic>?;
    final parsed = aiAssistant?['parsed_parameters'] as Map<String, dynamic>?;
    final pickup = parsed?['pickup'] as Map<String, dynamic>?;
    final destination = parsed?['destination'] as Map<String, dynamic>?;
    final parsedParameters = parsed == null
        ? null
        : ParsedAiParametersEntity(
            pickupLat: _asDouble(pickup?['lat'] ?? parsed['pickup_lat']),
            pickupLng: _asDouble(pickup?['lng'] ?? parsed['pickup_lng']),
            dropoffLat: _asDouble(destination?['lat'] ?? parsed['dropoff_lat']),
            dropoffLng: _asDouble(destination?['lng'] ?? parsed['dropoff_lng']),
            destinationName: aiAssistant?['destination_name'] as String?,
          );

    return CarRentalSearchResultModel(
      status: json['status'] == true || json['status'] == 'success',
      count: (json['count'] as num?)?.toInt() ?? total ?? offers.length,
      cheapest: cheapest,
      offers: offers,
      parsedParameters: parsedParameters,
    );
  }

  static double? _asDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  static CarRentalOfferModel? _findCheapest(List<CarRentalOfferModel> offers) {
    if (offers.isEmpty) return null;
    return offers.reduce((current, next) {
      final currentPrice = current.price ?? double.infinity;
      final nextPrice = next.price ?? double.infinity;
      return nextPrice < currentPrice ? next : current;
    });
  }
}
