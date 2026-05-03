import 'package:dio/dio.dart';
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
      return const NetworkFailure('انتهت مهلة الاتصال. تحقق من الإنترنت.');

    case DioExceptionType.connectionError:
      return const NetworkFailure('تعذر الاتصال. تحقق من الإنترنت.');

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      customPrint('HTTP $statusCode — $data', isError: true);

      final serverMessage = _extractMessage(data);

      if (statusCode == 401) return AuthFailure(serverMessage ?? 'غير مصرح. يرجى تسجيل الدخول.');
      if (statusCode == 404) return ServerFailure(serverMessage ?? 'العنصر المطلوب غير موجود.');
      if (statusCode == 422) return ServerFailure(serverMessage ?? 'بيانات غير صحيحة.');
      if (statusCode != null && statusCode >= 500) return ServerFailure(serverMessage ?? 'حدث خطأ في الخادم. حاول لاحقاً.');

      return ServerFailure(serverMessage ?? 'حدث خطأ غير متوقع.');

    case DioExceptionType.cancel:
      return const NetworkFailure('تم إلغاء الطلب.');

    default:
      return ServerFailure(e.message ?? 'حدث خطأ غير متوقع.');
  }
}

String? _extractMessage(dynamic data) {
  if (data is! Map<String, dynamic>) return null;

  // Try nested error object first: { "error": { "message": "...", "code": "..." } }
  final errorObj = data['error'];
  if (errorObj is Map<String, dynamic>) {
    final code = errorObj['code'] as String?;
    final msg = errorObj['message'] as String?;

    // Map known error codes to user-friendly Arabic messages
    final arabicMessage = _mapErrorCode(code);
    if (arabicMessage != null) return arabicMessage;

    if (msg != null && msg.isNotEmpty) return msg;
  }

  // Fallback: top-level message field
  final topMessage = data['message'] as String?;
  if (topMessage != null && topMessage.isNotEmpty) return topMessage;

  return null;
}

String? _mapErrorCode(String? code) {
  if (code == null) return null;
  const Map<String, String> _errorCodeMap = {
    'USER_NOT_FOUND':       'لم يتم العثور على حساب بهذا البريد الإلكتروني.',
    'INVALID_CREDENTIALS':  'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
    'INVALID_CODE':         'الكود الذي أدخلته غير صحيح. حاول مرة أخرى.',
    'EXPIRED_CODE':         'انتهت صلاحية الكود. يرجى طلب كود جديد.',
    'EMAIL_ALREADY_EXISTS': 'هذا البريد الإلكتروني مسجل مسبقاً.',
    'PHONE_ALREADY_EXISTS': 'رقم الهاتف مسجل مسبقاً.',
    'UNAUTHORIZED':         'غير مصرح. يرجى تسجيل الدخول.',
    'ACCOUNT_DISABLED':     'هذا الحساب موقوف. تواصل مع الدعم.',
    'TOO_MANY_ATTEMPTS':    'محاولات كثيرة. يرجى الانتظار قبل المحاولة مجدداً.',
  };
  return _errorCodeMap[code];
}


