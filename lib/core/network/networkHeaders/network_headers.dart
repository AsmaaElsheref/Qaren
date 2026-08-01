import '../../services/secure_storage_service.dart';

Map<String, String> networkHeaders({bool includeAuthorization = true}) {
  final token = SecureStorageService.cachedSessionToken;
  return {
    if (includeAuthorization && token != null && token.isNotEmpty)
      'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Accept-Language': 'ar',
  };
}
