import 'package:dio/dio.dart';
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
    _dio ??= Dio(
      BaseOptions(
        baseUrl: ApiRoutes.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        receiveDataWhenStatusError: true,
      ),
    );
    return _dio!;
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
        options: Options(
          headers: networkHeaders(),
          responseType: responseType,
        ),
      ),
      url: url,
      method: 'GET',
    );
  }

  static Future<Response<dynamic>> postData({
    required String url,
    Map<String, dynamic>? query,
    dynamic data,
    bool? removeHeader,
    ResponseType? responseType,
  }) async {
    return _request(
      () => _instance.post(
        url,
        queryParameters: query,
        data: data,
        options: Options(
          headers: removeHeader==true?null:networkHeaders(),
          responseType: responseType,
        ),
      ),
      url: url,
      method: 'POST',
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
      url: url,
      method: 'PUT',
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
      url: url,
      method: 'DELETE',
    );
  }

  // ── Private ────────────────────────────────────────────────────────────────

  static Future<Response<dynamic>> _request(
    Future<Response<dynamic>> Function() call, {
    required String url,
    required String method,
  }) async {
    try {
      customPrint('$method ➜ ${ApiRoutes.baseUrl}$url');
      return await call();
    } on DioException catch (e) {
      customPrint('Login Error ===> ${e.message}');
      customPrint('Login Error ===> ${e.error}');
      throw handleDioError(e);
    }
  }
}

