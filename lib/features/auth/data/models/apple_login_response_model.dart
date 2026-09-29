import 'user_model.dart';

class AppleLoginResponseModel {
  final bool success;
  final AppleLoginDataModel data;
  final String? message;

  const AppleLoginResponseModel({
    required this.success,
    required this.data,
    this.message,
  });

  factory AppleLoginResponseModel.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw const AppleLoginResponseException();
    }

    final success = json['success'];
    final message = json['message'] as String?;
    if (success != true) {
      throw AppleLoginRejectedException(message);
    }

    final rawData = json['data'];
    if (rawData is! Map<String, dynamic>) {
      throw const AppleLoginResponseException();
    }

    return AppleLoginResponseModel(
      success: true,
      data: AppleLoginDataModel.fromJson(rawData),
      message: message,
    );
  }
}

class AppleLoginDataModel {
  final UserModel user;
  final String token;

  const AppleLoginDataModel({required this.user, required this.token});

  factory AppleLoginDataModel.fromJson(Map<String, dynamic> json) {
    final token = json['token'];
    final rawUser = json['user'];
    if (token is! String ||
        token.trim().isEmpty ||
        rawUser is! Map<String, dynamic>) {
      throw const AppleLoginResponseException();
    }

    try {
      return AppleLoginDataModel(
        user: UserModel.fromJson(rawUser, token: token.trim()),
        token: token.trim(),
      );
    } catch (_) {
      throw const AppleLoginResponseException();
    }
  }
}

class AppleLoginRejectedException implements Exception {
  final String? message;

  const AppleLoginRejectedException(this.message);
}

class AppleLoginResponseException implements Exception {
  const AppleLoginResponseException();
}
