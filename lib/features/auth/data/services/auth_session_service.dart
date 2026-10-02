import '../../../../core/constants/app_constants.dart';
import '../../../../core/localStorage/cache_helper.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/guest_auth_data.dart';
import '../../domain/entities/user_entity.dart';

/// Persists and restores authenticated and guest API sessions.
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
      await _secureStorage.saveActiveSession(token: token, isGuest: false);
      await _save(AppConstants.userId, user.id);
      await _save(AppConstants.userName, user.name);
      await _save(AppConstants.userPhone, user.phone);
      await _save(AppConstants.userEmail, user.email);
    } catch (_) {
      await clear();
      rethrow;
    }
  }

  Future<void> persistGuest(GuestAuthData guest) async {
    final token = guest.token.trim();
    if (!guest.isGuest || token.isEmpty) {
      throw const AuthSessionException('Invalid guest session.');
    }

    try {
      await _clearUserData();
      await _secureStorage.saveActiveSession(token: token, isGuest: true);
    } catch (_) {
      await clear();
      rethrow;
    }
  }

  /// Returns the restored Sanctum token, migrating older cached sessions to
  /// secure storage when necessary.
  Future<AuthSession> restore() async {
    final secureToken = (await _secureStorage.getSessionToken())?.trim();
    if (secureToken != null && secureToken.isNotEmpty) {
      await CacheHelper.removeData(key: AppConstants.token);
      final isGuest = await _secureStorage.getSessionIsGuest();
      // A missing flag belongs to an app version predating guest mode, where
      // every stored token represented a fully authenticated user.
      return isGuest == true
          ? AuthSession.guest(secureToken)
          : AuthSession.authenticated(secureToken);
    }

    final cachedToken =
        (CacheHelper.getData(key: AppConstants.token) as String?)?.trim();
    if (cachedToken == null || cachedToken.isEmpty) {
      await _secureStorage.clearSessionToken();
      return const AuthSession.unauthenticated();
    }

    await _secureStorage.saveActiveSession(token: cachedToken, isGuest: false);
    await CacheHelper.removeData(key: AppConstants.token);
    return AuthSession.authenticated(cachedToken);
  }

  /// Backward-compatible token restoration for legacy callers.
  Future<String?> restoreToken() async => (await restore()).token;

  Future<AuthSession> authenticatedSession(UserEntity user) async {
    await persist(user);
    return AuthSession.authenticated(user.token!.trim());
  }

  Future<AuthSession> guestSession(GuestAuthData guest) async {
    await persistGuest(guest);
    return AuthSession.guest(guest.token.trim());
  }

  Future<void> clear() async {
    await _secureStorage.clearSessionToken();
    await _clearUserData();
  }

  Future<void> _clearUserData() async {
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
