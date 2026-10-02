import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keys for secure storage entries.
abstract class _Keys {
  static const sessionToken = 'session_access_token';
  static const sessionIsGuest = 'session_is_guest';
  static const refreshToken = 'bio_refresh_token';
  static const accessToken = 'bio_access_token';
  static const biometricsEnabled = 'biometrics_enabled';
  // Fallback only — used when backend has no refresh-token support
  static const fallbackEmail = 'bio_fallback_email';
  static const fallbackPassword = 'bio_fallback_password';
}

class SecureStorageService {
  static String? _cachedSessionToken;

  static String? get cachedSessionToken => _cachedSessionToken;

  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  // ── Biometrics enabled flag ──────────────────────────────────
  Future<bool> isBiometricsEnabled() async {
    final value = await _storage.read(key: _Keys.biometricsEnabled);
    return value == 'true';
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    if (enabled) {
      await _storage.write(key: _Keys.biometricsEnabled, value: 'true');
    } else {
      await _storage.delete(key: _Keys.biometricsEnabled);
    }
  }

  /// Sanctum token for the active application session.
  Future<void> saveSessionToken(String token) async {
    await _storage.write(key: _Keys.sessionToken, value: token);
    _cachedSessionToken = token;
  }

  /// Stores the active API token together with its explicit session type.
  ///
  /// Guest state is deliberately persisted separately from the token so the
  /// application never infers access level from token presence alone.
  Future<void> saveActiveSession({
    required String token,
    required bool isGuest,
  }) async {
    final normalizedToken = token.trim();
    if (normalizedToken.isEmpty) {
      throw ArgumentError.value(token, 'token', 'Token must not be empty.');
    }

    // When creating a guest session, write the restrictive flag first. When
    // upgrading a guest, replace the token first. An interrupted write can
    // therefore never elevate a guest token to authenticated access.
    if (isGuest) {
      await _storage.write(key: _Keys.sessionIsGuest, value: 'true');
      await saveSessionToken(normalizedToken);
    } else {
      await saveSessionToken(normalizedToken);
      await _storage.write(key: _Keys.sessionIsGuest, value: 'false');
    }
  }

  Future<String?> getSessionToken() async {
    final token = await _storage.read(key: _Keys.sessionToken);
    _cachedSessionToken = token;
    return token;
  }

  Future<bool?> getSessionIsGuest() async {
    final value = await _storage.read(key: _Keys.sessionIsGuest);
    if (value == null) return null;
    return value == 'true';
  }

  Future<void> clearSessionToken() async {
    _cachedSessionToken = null;
    await Future.wait([
      _storage.delete(key: _Keys.sessionToken),
      _storage.delete(key: _Keys.sessionIsGuest),
    ]);
  }

  // ── Token storage ────────────────────────────────────────────
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: _Keys.accessToken, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _Keys.refreshToken, value: refreshToken);
    }
  }

  Future<String?> getAccessToken() => _storage.read(key: _Keys.accessToken);

  Future<String?> getRefreshToken() => _storage.read(key: _Keys.refreshToken);

  Future<bool> hasStoredTokens() async {
    final token = await _storage.read(key: _Keys.accessToken);
    return token != null && token.isNotEmpty;
  }

  // ── Fallback credentials (only if backend has NO refresh tokens) ──
  Future<void> saveFallbackCredentials({
    required String email,
    required String password,
  }) async {
    await _storage.write(key: _Keys.fallbackEmail, value: email);
    await _storage.write(key: _Keys.fallbackPassword, value: password);
  }

  Future<({String email, String password})?> getFallbackCredentials() async {
    final email = await _storage.read(key: _Keys.fallbackEmail);
    final password = await _storage.read(key: _Keys.fallbackPassword);
    if (email != null && password != null) {
      return (email: email, password: password);
    }
    return null;
  }

  // ── Clear everything ─────────────────────────────────────────
  Future<void> clearAll() async {
    _cachedSessionToken = null;
    await _storage.deleteAll();
  }

  /// Clear only biometric-related data (keeps other app data).
  Future<void> clearBiometricData() async {
    await _storage.delete(key: _Keys.refreshToken);
    await _storage.delete(key: _Keys.accessToken);
    await _storage.delete(key: _Keys.biometricsEnabled);
    await _storage.delete(key: _Keys.fallbackEmail);
    await _storage.delete(key: _Keys.fallbackPassword);
  }
}
