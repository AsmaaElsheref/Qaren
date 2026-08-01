import '../../../../core/constants/app_constants.dart';
import '../../../../core/localStorage/cache_helper.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../domain/entities/user_entity.dart';

/// Persists and restores the application's Sanctum-authenticated session.
///
/// The token is stored only in platform-backed secure storage. Dio reads the
/// in-memory copy populated by [SecureStorageService] after restoration.
class AuthSessionService {
  final SecureStorageService _secureStorage;

  const AuthSessionService(this._secureStorage);

  Future<void> persist(UserEntity user) async {
    final token = user.token?.trim();
    if (token == null || token.isEmpty) {
      throw const AuthSessionException('Authentication token is missing.');
    }

    try {
      await _secureStorage.saveSessionToken(token);
      await _save(AppConstants.userId, user.id);
      await _save(AppConstants.userName, user.name);
      await _save(AppConstants.userPhone, user.phone);
      await _save(AppConstants.userEmail, user.email);
    } catch (_) {
      await clear();
      rethrow;
    }
  }

  /// Returns the restored Sanctum token, migrating older cached sessions to
  /// secure storage when necessary.
  Future<String?> restoreToken() async {
    final secureToken = (await _secureStorage.getSessionToken())?.trim();
    if (secureToken != null && secureToken.isNotEmpty) {
      await CacheHelper.removeData(key: AppConstants.token);
      return secureToken;
    }

    final cachedToken =
        (CacheHelper.getData(key: AppConstants.token) as String?)?.trim();
    if (cachedToken == null || cachedToken.isEmpty) return null;

    await _secureStorage.saveSessionToken(cachedToken);
    await CacheHelper.removeData(key: AppConstants.token);
    return cachedToken;
  }

  Future<void> clear() async {
    await _secureStorage.clearSessionToken();
    await Future.wait([
      CacheHelper.removeData(key: AppConstants.token),
      CacheHelper.removeData(key: AppConstants.userId),
      CacheHelper.removeData(key: AppConstants.userName),
      CacheHelper.removeData(key: AppConstants.userPhone),
      CacheHelper.removeData(key: AppConstants.userEmail),
    ]);
  }

  Future<void> _save(String key, Object value) async {
    final saved = await CacheHelper.saveData(key: key, value: value);
    if (!saved) throw AuthSessionException('Failed to persist $key.');
  }
}

class AuthSessionException implements Exception {
  final String message;

  const AuthSessionException(this.message);
}
