import '../../../../core/network/handelError/errors/failures.dart';
import '../../../../core/localization/easy_localization.dart';
import '../../../../core/utils/either.dart';
import 'package:qaren/features/auth/domain/entities/login_params.dart';
import 'package:qaren/features/auth/domain/entities/register_params.dart';
import 'package:qaren/features/auth/domain/entities/update_profile_params.dart';
import 'package:qaren/features/auth/domain/entities/user_entity.dart';
import 'package:qaren/features/auth/domain/repositories/auth_repository.dart';
import 'package:qaren/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:qaren/features/auth/data/models/google_login_response_model.dart';
import 'package:qaren/features/auth/data/services/google_sign_in_service.dart';
import 'package:qaren/features/auth/data/services/apple_sign_in_service.dart';
import 'package:qaren/features/auth/data/models/apple_login_response_model.dart';
import 'package:qaren/features/auth/data/models/guest_auth_response_model.dart';
import 'package:qaren/features/auth/domain/entities/guest_auth_data.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final GoogleSignInService _googleSignInService;
  final AppleSignInService _appleSignInService;

  const AuthRepositoryImpl(
    this._remoteDataSource,
    this._googleSignInService,
    this._appleSignInService,
  );

  @override
  Future<Either<Failure, UserEntity>> login(LoginParams params) async {
    try {
      final user = await _remoteDataSource.login(params);
      return Either.rightOf(user);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, GuestAuthData>> continueAsGuest() async {
    try {
      final guest = await _remoteDataSource.continueAsGuest();
      return Either.rightOf(guest);
    } on NetworkFailure catch (failure) {
      return Either.leftOf(failure);
    } on Failure catch (failure) {
      return Either.leftOf(failure);
    } on GuestAuthResponseException {
      return Either.leftOf(AuthFailure('auth.guest_login_failed'.tr()));
    } catch (_) {
      return Either.leftOf(AuthFailure('auth.guest_login_failed'.tr()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithGoogle() async {
    try {
      final accessToken = await _googleSignInService.getAccessToken();
      final user = await _remoteDataSource.loginWithGoogleAccessToken(
        accessToken,
      );
      return Either.rightOf(user);
    } on GoogleSignInCancelledException {
      return Either.leftOf(
        AuthCancelledFailure('auth.login.googleLoginCancelled'.tr()),
      );
    } on GoogleAccessTokenMissingException {
      return Either.leftOf(
        AuthFailure('auth.login.googleAccessTokenMissing'.tr()),
      );
    } on GoogleAccountUnavailableException {
      return Either.leftOf(
        AuthFailure('auth.login.googleAccountNotAvailable'.tr()),
      );
    } on GoogleSignInSdkException {
      return Either.leftOf(AuthFailure('auth.login.googleLoginFailed'.tr()));
    } on GoogleLoginRejectedException catch (error) {
      final isInvalidToken =
          error.message?.trim().toLowerCase().contains(
            'invalid google token',
          ) ??
          false;
      return Either.leftOf(
        AuthFailure(
          isInvalidToken
              ? 'auth.login.googleInvalidToken'.tr()
              : 'auth.login.googleLoginFailed'.tr(),
        ),
      );
    } on GoogleLoginResponseException {
      return Either.leftOf(AuthFailure('auth.login.googleLoginFailed'.tr()));
    } on NetworkFailure catch (failure) {
      return Either.leftOf(failure);
    } on AuthFailure {
      return Either.leftOf(AuthFailure('auth.login.googleInvalidToken'.tr()));
    } on Failure {
      return Either.leftOf(AuthFailure('auth.login.googleLoginFailed'.tr()));
    } catch (_) {
      return Either.leftOf(AuthFailure('auth.login.googleLoginFailed'.tr()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithApple() async {
    try {
      final credential = await _appleSignInService.getCredential();
      final user = await _remoteDataSource.loginWithApple(credential);
      return Either.rightOf(user);
    } on AppleSignInCancelledException {
      return Either.leftOf(
        AuthCancelledFailure('auth.login.appleLoginCancelled'.tr()),
      );
    } on AppleCredentialsMissingException {
      return Either.leftOf(
        AuthFailure('auth.login.appleCredentialsMissing'.tr()),
      );
    } on AppleAccountUnavailableException {
      return Either.leftOf(
        AuthFailure('auth.login.appleAccountNotAvailable'.tr()),
      );
    } on AppleSignInSdkException {
      return Either.leftOf(AuthFailure('auth.login.appleLoginFailed'.tr()));
    } on NetworkFailure catch (failure) {
      return Either.leftOf(failure);
    } on Failure {
      return Either.leftOf(AuthFailure('auth.login.appleTokenRejected'.tr()));
    } on AppleLoginRejectedException {
      return Either.leftOf(AuthFailure('auth.login.appleTokenRejected'.tr()));
    } on AppleLoginResponseException {
      return Either.leftOf(AuthFailure('auth.login.appleLoginFailed'.tr()));
    } catch (_) {
      return Either.leftOf(AuthFailure('auth.login.appleLoginFailed'.tr()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(RegisterParams params) async {
    try {
      final user = await _remoteDataSource.register(params);
      return Either.rightOf(user);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(AuthFailure('auth.signup.failed'.tr()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getMe() async {
    try {
      final user = await _remoteDataSource.getMe();
      return Either.rightOf(user);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(AuthFailure('auth.errors.fetchUserFailed'.tr()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(
    UpdateProfileParams params,
  ) async {
    try {
      final user = await _remoteDataSource.updateProfile(params);
      return Either.rightOf(user);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(AuthFailure('auth.errors.updateProfileFailed'.tr()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await _remoteDataSource.deleteAccount();
      return Either.rightOf(null);
    } on Failure catch (failure) {
      return Either.leftOf(failure);
    } catch (_) {
      return Either.leftOf(ServerFailure('profile.deleteAccount.failed'.tr()));
    }
  }

  @override
  Future<Either<Failure, void>> loginWithBiometrics(
    UserTypeTab userType,
  ) async {
    try {
      await _remoteDataSource.loginWithBiometrics(userType);
      return Either.rightOf(null);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(AuthFailure('auth.errors.biometricAuthFailed'.tr()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String login) async {
    try {
      await _remoteDataSource.forgotPassword(login);
      return Either.rightOf(null);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> verifyCode(String login, String code) async {
    try {
      await _remoteDataSource.verifyCode(login, code);
      return Either.rightOf(null);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(ServerFailure('errors.invalidCode'.tr()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    String login,
    String code,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      await _remoteDataSource.resetPassword(
        login,
        code,
        password,
        passwordConfirmation,
      );
      return Either.rightOf(null);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(ServerFailure('auth.resetPassword.failed'.tr()));
    }
  }
}
