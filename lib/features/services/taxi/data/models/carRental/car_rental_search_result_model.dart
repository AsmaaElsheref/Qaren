import '../../../domain/entities/car_rental_search_result_entity.dart';
import 'car_rental_offer_model.dart';

class CarRentalSearchResultModel extends CarRentalSearchResultEntity {
  const CarRentalSearchResultModel({
    super.status,
    super.count,
    super.cheapest,
    super.offers,
  });

  factory CarRentalSearchResultModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];

    final offers = dataList
        .whereType<Map<String, dynamic>>()
        .map(CarRentalOfferModel.fromJson)
        .toList();

    final cheapestJson = json['cheapest'] as Map<String, dynamic>?;

    return CarRentalSearchResultModel(
      status: json['status'] == true,
      count: (json['count'] as num?)?.toInt() ?? offers.length,
      cheapest: cheapestJson != null
          ? CarRentalOfferModel.fromJson(cheapestJson)
          : null,
      offers: offers,
    );
  }
}

