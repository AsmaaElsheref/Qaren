import 'package:dio/dio.dart';
import '../../utils/print/custom_print.dart';
import 'errors/failures.dart';

/// Maps a [DioException] to a domain [Failure].
///
/// This keeps the network layer decoupled from UI (no navigation/toast here).
/// Presenters / notifiers handle failure display.
Failure
handleDioError(DioException e) {
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
  if (data is Map<String, dynamic>) {
    return data['message'] as String?;
  }
  return null;
}

