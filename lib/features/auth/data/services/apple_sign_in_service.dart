import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../domain/entities/apple_login_params.dart';

/// Owns communication with Apple's native authentication SDK.
class AppleSignInService {
  const AppleSignInService();

  Future<AppleLoginParams> getCredential() async {
    try {
      if (!_isNativeApplePlatform || !await SignInWithApple.isAvailable()) {
        throw const AppleAccountUnavailableException();
      }

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final identityToken = credential.identityToken?.trim();
      final appleId = credential.userIdentifier?.trim();
      if ((identityToken == null || identityToken.isEmpty) &&
          (appleId == null || appleId.isEmpty)) {
        throw const AppleCredentialsMissingException();
      }

      debugPrint('Apple credentials received: yes');
      final firstName = credential.givenName?.trim();
      final lastName = credential.familyName?.trim();
      final fullName = [
        if (firstName != null && firstName.isNotEmpty) firstName,
        if (lastName != null && lastName.isNotEmpty) lastName,
      ].join(' ');

      return AppleLoginParams(
        identityToken: identityToken,
        appleId: appleId,
        email: credential.email,
        name: fullName.isEmpty ? null : fullName,
        firstName: firstName,
        lastName: lastName,
      );
    } on SignInWithAppleAuthorizationException catch (error) {
      if (error.code == AuthorizationErrorCode.canceled) {
        throw const AppleSignInCancelledException();
      }
      debugPrint('Apple authentication failed at SDK stage.');
      throw const AppleSignInSdkException();
    } on SignInWithAppleNotSupportedException {
      throw const AppleAccountUnavailableException();
    } on AppleAuthenticationException {
      rethrow;
    } catch (_) {
      debugPrint('Apple authentication failed unexpectedly.');
      throw const AppleSignInSdkException();
    }
  }

  bool get _isNativeApplePlatform =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
}

sealed class AppleAuthenticationException implements Exception {
  const AppleAuthenticationException();
}

final class AppleSignInCancelledException extends AppleAuthenticationException {
  const AppleSignInCancelledException();
}

final class AppleCredentialsMissingException
    extends AppleAuthenticationException {
  const AppleCredentialsMissingException();
}

final class AppleAccountUnavailableException
    extends AppleAuthenticationException {
  const AppleAccountUnavailableException();
}

final class AppleSignInSdkException extends AppleAuthenticationException {
  const AppleSignInSdkException();
}
