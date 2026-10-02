import '../../domain/entities/guest_auth_data.dart';

class GuestAuthResponseModel {
  final bool success;
  final GuestAuthDataModel data;
  final String? message;

  const GuestAuthResponseModel({
    required this.success,
    required this.data,
    this.message,
  });

  factory GuestAuthResponseModel.fromJson(dynamic json) {
    if (json is! Map) {
      throw const GuestAuthResponseException('Invalid guest response.');
    }

    final body = Map<String, dynamic>.from(json);
    final rawData = body['data'];
    if (rawData is! Map) {
      throw const GuestAuthResponseException('Guest data is missing.');
    }

    final success = body['success'];
    if (success == false) {
      throw const GuestAuthResponseException('Guest request was rejected.');
    }

    final data = Map<String, dynamic>.from(rawData);
    data.putIfAbsent('is_guest', () => body['is_guest'] ?? body['isGuest']);

    return GuestAuthResponseModel(
      success: success is bool ? success : true,
      data: GuestAuthDataModel.fromJson(data),
      message: body['message']?.toString(),
    );
  }
}

class GuestAuthDataModel extends GuestAuthData {
  const GuestAuthDataModel({required super.token, required super.isGuest});

  factory GuestAuthDataModel.fromJson(Map<String, dynamic> json) {
    final token = (json['token'] ?? json['access_token'])?.toString().trim();
    final isGuest = _parseBoolean(json['is_guest'] ?? json['isGuest']);

    if (token == null || token.isEmpty) {
      throw const GuestAuthResponseException('Guest token is missing.');
    }
    if (!isGuest) {
      throw const GuestAuthResponseException('Invalid guest session type.');
    }

    return GuestAuthDataModel(token: token, isGuest: true);
  }

  static bool _parseBoolean(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }
}

class GuestAuthResponseException implements Exception {
  final String message;

  const GuestAuthResponseException(this.message);
}
