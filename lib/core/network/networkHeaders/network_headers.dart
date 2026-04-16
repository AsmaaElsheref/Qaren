import '../../constants/app_constants.dart';
import '../../localStorage/cache_helper.dart';

Map<String, String> networkHeaders() {
  final token = CacheHelper.getData(key: AppConstants.token) as String?;
  return {
    if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Accept-Language': 'ar'
  };
}

