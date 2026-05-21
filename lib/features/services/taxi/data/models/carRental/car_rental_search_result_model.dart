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
    final dataList = json['data'] as List<dynamic>? ?? [];

    final offers = dataList
        .whereType<Map<String, dynamic>>()
        .map(CarRentalOfferModel.fromJson)
        .toList();

    final cheapestJson = json['cheapest'] as Map<String, dynamic>?;

    // ── AI assistant block (optional — only present in ai-search response) ──
    final aiAssistant = json['ai_assistant'] as Map<String, dynamic>?;
    final parsed =
        aiAssistant?['parsed_parameters'] as Map<String, dynamic>?;
    final parsedParameters = parsed == null
        ? null
        : ParsedAiParametersEntity(
            pickupLat: _asDouble(parsed['pickup_lat']),
            pickupLng: _asDouble(parsed['pickup_lng']),
            dropoffLat: _asDouble(parsed['dropoff_lat']),
            dropoffLng: _asDouble(parsed['dropoff_lng']),
            destinationName: aiAssistant?['destination_name'] as String?,
          );

    return CarRentalSearchResultModel(
      status: json['status'] == true,
      count: (json['count'] as num?)?.toInt() ?? offers.length,
      cheapest: cheapestJson != null
          ? CarRentalOfferModel.fromJson(cheapestJson)
          : null,
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
}
