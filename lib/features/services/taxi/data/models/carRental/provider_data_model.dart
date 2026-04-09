
import '../../../domain/entities/provider_data_entity.dart';

class ProviderDataModel extends ProviderDataEntity {
  const ProviderDataModel({
    super.rating,
    super.isInstantBook,
    super.freeCancellation,
  });

  factory ProviderDataModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const ProviderDataModel();

    return ProviderDataModel(
      rating: _parseDouble(json['rating']),
      isInstantBook: json['is_instant_book'] == true,
      freeCancellation: json['free_cancellation'] == true,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

