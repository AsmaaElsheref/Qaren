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
      customPrint('HTTP $statusCode — $data', isError: true);

      final serverMessage = _extractMessage(data);

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
      return ServerFailure(e.message ?? 'errors.unexpected'.tr());
  }
}

String? _extractMessage(dynamic data) {
  if (data is! Map<String, dynamic>) return null;

  // Try nested error object first: { "error": { "message": "...", "code": "..." } }
  final errorObj = data['error'];
  if (errorObj is Map<String, dynamic>) {
    final code = errorObj['code'] as String?;
    final msg = errorObj['message'] as String?;

    // Map known error codes to localized messages
    final localizedMessage = _mapErrorCode(code);
    if (localizedMessage != null) return localizedMessage;

    if (msg != null && msg.isNotEmpty) return msg;
  }

  // Fallback: top-level message field
  final topMessage = data['message'] as String?;
  if (topMessage != null && topMessage.isNotEmpty) return topMessage;

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
