import 'package:intl/intl.dart';

import '../../services/secure_storage_service.dart';

Map<String, String> networkHeaders({bool includeAuthorization = true}) {
  final token = SecureStorageService.cachedSessionToken;
  final localeName = Intl.getCurrentLocale().toLowerCase();
  final languageCode = localeName == 'ar' || localeName.startsWith('ar_')
      ? 'ar'
      : 'en';

  return {
    if (includeAuthorization && token != null && token.isNotEmpty)
      'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Accept-Language': languageCode,
  };
}
