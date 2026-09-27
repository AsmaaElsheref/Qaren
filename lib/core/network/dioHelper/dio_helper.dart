import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../utils/print/custom_print.dart';
import '../apiRoutes/api_routes.dart';
import '../handelError/handel_error.dart';
import '../networkHeaders/network_headers.dart';

/// Low-level HTTP client wrapper around [Dio].
///
/// - Automatically injects auth headers via [networkHeaders].
/// - Throws a [Failure] subclass on any Dio error so callers get typed errors.
/// - The singleton [_dio] instance is created lazily; call [init] if you want
///   to recreate it (e.g. after token refresh).
class DioHelper {
  DioHelper._();

  static Dio? _dio;

  static Dio get _instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiRoutes.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        receiveDataWhenStatusError: true,
        followRedirects: false,
        maxRedirects: 0,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['lang'] = _currentLanguageCode;
          customPrint('REQUEST ${options.method} ➜ ${options.uri}');
          if (options.data != null) {
            customPrint('REQUEST BODY ➜ ${_sanitizeForLog(options.data)}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          customPrint(
            'RESPONSE ${response.statusCode} ⇦ ${response.requestOptions.uri}',
          );
          customPrint('RESPONSE DATA ⇦ ${_sanitizeForLog(response.data)}');
          handler.next(response);
        },
        onError: (error, handler) {
          final response = error.response;
          if (response != null) {
            customPrint(
              'RESPONSE ${response.statusCode} ⇦ ${response.requestOptions.uri}',
              isError: true,
            );
            customPrint(
              'RESPONSE DATA ⇦ ${_sanitizeForLog(response.data)}',
              isError: true,
            );
          } else {
            customPrint(
              'REQUEST FAILED ⇦ ${error.requestOptions.uri}: ${error.message}',
              isError: true,
            );
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  static String get _currentLanguageCode {
    final localeName = Intl.getCurrentLocale().toLowerCase();
    return localeName == 'ar' || localeName.startsWith('ar_') ? 'ar' : 'en';
  }

  static dynamic _sanitizeForLog(dynamic value) {
    if (value is Map) {
      return value.map((key, item) {
        final keyText = key.toString();
        return MapEntry(
          keyText,
          _isSensitiveKey(keyText) ? '***' : _sanitizeForLog(item),
        );
      });
    }
    if (value is Iterable) {
      return value.map(_sanitizeForLog).toList(growable: false);
    }
    return value;
  }

  static bool _isSensitiveKey(String key) {
    final normalized = key.toLowerCase().replaceAll(RegExp('[^a-z]'), '');
    return normalized == 'authorization' ||
        normalized.contains('token') ||
        normalized.contains('password') ||
        normalized.contains('secret');
  }

  /// Re-initialises the Dio instance (e.g. after changing base URL or token).
  static void init() => _dio = null;

  // ── Public API ─────────────────────────────────────────────────────────────

  static Future<Response<dynamic>> getData({
    required String url,
    Map<String, dynamic>? query,
    dynamic data,
    ResponseType? responseType,
  }) async {
    return _request(
      () => _instance.get(
        url,
        queryParameters: query,
        data: data,
        options: Options(headers: networkHeaders(), responseType: responseType),
      ),
    );
  }

  static Future<Response<dynamic>> postData({
    required String url,
    Map<String, dynamic>? query,
    dynamic data,
    bool? removeHeader,
    bool authenticated = true,
    ResponseType? responseType,
  }) async {
    return _request(
      () => _instance.post(
        url,
        queryParameters: query,
        data: data,
        options: Options(
          headers: removeHeader == true
              ? null
              : networkHeaders(includeAuthorization: authenticated),
          responseType: responseType,
        ),
      ),
    );
  }

  static Future<Response<dynamic>> putData({
    required String url,
    dynamic data,
  }) async {
    return _request(
      () => _instance.put(
        url,
        data: data,
        options: Options(headers: networkHeaders()),
      ),
    );
  }

  static Future<Response<dynamic>> deleteData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    return _request(
      () => _instance.delete(
        url,
        queryParameters: query,
        options: Options(headers: networkHeaders()),
      ),
    );
  }

  // ── Private ────────────────────────────────────────────────────────────────

  static Future<Response<dynamic>> _request(
    Future<Response<dynamic>> Function() call,
  ) async {
    try {
      return await call();
    } on DioException catch (e) {
      customPrint('Request Error ===> ${e.message}', isError: true);
      throw handleDioError(e);
    }
  }
}
