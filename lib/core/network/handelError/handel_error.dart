import 'package:dio/dio.dart';
import 'package:qaren/core/localization/easy_localization.dart';
import '../../utils/print/custom_print.dart';
import 'errors/failures.dart';

/// Maps a [DioException] to a domain [Failure].
///
/// This keeps the network layer decoupled from UI (no navigation/toast here).
/// Presenters / notifiers handle failure display.
Failure handleDioError(DioException e) {
  customPrint('DioException: ${e.message}', isException: true);

  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return NetworkFailure('errors.timeout'.tr());

    case DioExceptionType.connectionError:
      return NetworkFailure('errors.network'.tr());

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;

      final serverMessage = _extractLocalizedMessage(data);

      if (statusCode == 401) {
        return AuthFailure(serverMessage ?? 'errors.unauthorized'.tr());
      }
      if (statusCode == 404) {
        return ServerFailure(serverMessage ?? 'errors.notFound'.tr());
      }
      if (statusCode == 422) {
        return ServerFailure(serverMessage ?? 'errors.validation'.tr());
      }
      if (statusCode != null && statusCode >= 500) {
        return ServerFailure(serverMessage ?? 'errors.server'.tr());
      }

      return ServerFailure(serverMessage ?? 'errors.unexpected'.tr());

    case DioExceptionType.cancel:
      return NetworkFailure('errors.cancelled'.tr());

    default:
      return ServerFailure('errors.unexpected'.tr());
  }
}

String? _extractLocalizedMessage(dynamic data) {
  if (data is! Map<String, dynamic>) return null;

  // Try nested error object first: { "error": { "message": "...", "code": "..." } }
  final errorObj = data['error'];
  if (errorObj is Map<String, dynamic>) {
    final code = errorObj['code'] as String?;
    final msg = errorObj['message'] as String?;

    // Map known error codes to localized messages
    final localizedMessage = _mapErrorCode(code);
    if (localizedMessage != null) return localizedMessage;

    final localizedMessageFromText = _mapKnownMessage(msg);
    if (localizedMessageFromText != null) return localizedMessageFromText;
  }

  // Fallback: top-level message field
  final topMessage = data['message'] as String?;
  final localizedTopMessage = _mapKnownMessage(topMessage);
  if (localizedTopMessage != null) return localizedTopMessage;

  return null;
}

String? _mapKnownMessage(String? message) {
  final normalized = message?.trim().toLowerCase();
  if (normalized == null || normalized.isEmpty) return null;

  const knownMessages = {
    'user not found': 'errors.userNotFound',
    'invalid credentials': 'errors.invalidCredentials',
    'invalid code': 'errors.invalidCode',
    'code expired': 'errors.expiredCode',
    'email already exists': 'errors.emailExists',
    'phone already exists': 'errors.phoneExists',
    'account disabled': 'errors.accountDisabled',
    'too many attempts': 'errors.tooManyAttempts',
  };

  for (final entry in knownMessages.entries) {
    if (normalized.contains(entry.key)) return entry.value.tr();
  }
  return null;
}

String? _mapErrorCode(String? code) {
  if (code == null) return null;
  const errorCodeMap = {
    'USER_NOT_FOUND': 'errors.userNotFound',
    'INVALID_CREDENTIALS': 'errors.invalidCredentials',
    'INVALID_CODE': 'errors.invalidCode',
    'EXPIRED_CODE': 'errors.expiredCode',
    'EMAIL_ALREADY_EXISTS': 'errors.emailExists',
    'PHONE_ALREADY_EXISTS': 'errors.phoneExists',
    'UNAUTHORIZED': 'errors.unauthorized',
    'ACCOUNT_DISABLED': 'errors.accountDisabled',
    'TOO_MANY_ATTEMPTS': 'errors.tooManyAttempts',
  };
  final key = errorCodeMap[code];
  return key?.tr();
}
