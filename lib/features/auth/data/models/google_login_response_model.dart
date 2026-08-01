import 'user_model.dart';

class GoogleLoginResponseModel {
  final bool success;
  final GoogleLoginDataModel data;
  final String? message;

  const GoogleLoginResponseModel({
    required this.success,
    required this.data,
    this.message,
  });

  factory GoogleLoginResponseModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const GoogleLoginResponseException();
    }

    final success = json['success'];
    final message = json['message'] as String?;
    if (success != true) {
      throw GoogleLoginRejectedException(message);
    }

    final rawData = json['data'];
    if (rawData is! Map<String, dynamic>) {
      throw const GoogleLoginResponseException();
    }

    return GoogleLoginResponseModel(
      success: true,
      data: GoogleLoginDataModel.fromJson(rawData),
      message: message,
    );
  }
}

class GoogleLoginDataModel {
  final UserModel user;
  final String token;

  const GoogleLoginDataModel({required this.user, required this.token});

  factory GoogleLoginDataModel.fromJson(Map<String, dynamic> json) {
    final token = json['token'];
    final rawUser = json['user'];
    if (token is! String ||
        token.trim().isEmpty ||
        rawUser is! Map<String, dynamic>) {
      throw const GoogleLoginResponseException();
    }

    try {
      return GoogleLoginDataModel(
        user: UserModel.fromJson(rawUser, token: token.trim()),
        token: token.trim(),
      );
    } catch (_) {
      throw const GoogleLoginResponseException();
    }
  }
}

class GoogleLoginRejectedException implements Exception {
  final String? message;

  const GoogleLoginRejectedException(this.message);
}

class GoogleLoginResponseException implements Exception {
  const GoogleLoginResponseException();
}
