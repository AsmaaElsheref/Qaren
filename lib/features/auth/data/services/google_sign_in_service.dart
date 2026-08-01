import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Owns all communication with the Google Sign-In SDK.
class GoogleSignInService {
  static const List<String> _basicProfileScopes = [
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];

  final GoogleSignIn _googleSignIn;
  Future<void>? _initialization;

  GoogleSignInService({GoogleSignIn? googleSignIn})
    : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  Future<String> getAccessToken() async {
    try {
      await _ensureInitialized();

      if (!_googleSignIn.supportsAuthenticate()) {
        throw const GoogleAccountUnavailableException();
      }

      final account = await _googleSignIn.authenticate(
        scopeHint: _basicProfileScopes,
      );
      final authorization =
          await account.authorizationClient.authorizationForScopes(
            _basicProfileScopes,
          ) ??
          await account.authorizationClient.authorizeScopes(
            _basicProfileScopes,
          );

      final accessToken = authorization.accessToken.trim();
      if (accessToken.isEmpty) {
        throw const GoogleAccessTokenMissingException();
      }

      debugPrint('Google authentication token received: yes');
      return accessToken;
    } on GoogleSignInException catch (error) {
      switch (error.code) {
        case GoogleSignInExceptionCode.canceled:
        case GoogleSignInExceptionCode.interrupted:
          throw const GoogleSignInCancelledException();
        case GoogleSignInExceptionCode.uiUnavailable:
          throw const GoogleAccountUnavailableException();
        default:
          debugPrint('Google authentication failed at SDK stage.');
          throw const GoogleSignInSdkException();
      }
    } on GoogleAuthenticationException {
      rethrow;
    } catch (_) {
      debugPrint('Google authentication failed unexpectedly.');
      throw const GoogleSignInSdkException();
    }
  }

  Future<void> signOut() async {
    await _ensureInitialized();
    await _googleSignIn.signOut();
  }

  Future<void> _ensureInitialized() =>
      _initialization ??= _googleSignIn.initialize();
}

sealed class GoogleAuthenticationException implements Exception {
  const GoogleAuthenticationException();
}

final class GoogleSignInCancelledException
    extends GoogleAuthenticationException {
  const GoogleSignInCancelledException();
}

final class GoogleAccessTokenMissingException
    extends GoogleAuthenticationException {
  const GoogleAccessTokenMissingException();
}

final class GoogleAccountUnavailableException
    extends GoogleAuthenticationException {
  const GoogleAccountUnavailableException();
}

final class GoogleSignInSdkException extends GoogleAuthenticationException {
  const GoogleSignInSdkException();
}
