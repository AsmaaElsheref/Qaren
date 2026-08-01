import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/handelError/errors/failures.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/services/auth_session_service.dart';
import '../../data/services/google_sign_in_service.dart';
import '../../domain/entities/login_params.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/google_login_usecase.dart';
import 'login_state.dart';

// ── Data layer ─────────────────────────────────────────────────────────────────
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => const AuthRemoteDataSourceImpl(),
);

final googleSignInServiceProvider = Provider<GoogleSignInService>(
  (ref) => GoogleSignInService(),
);

final authSessionServiceProvider = Provider<AuthSessionService>(
  (ref) => AuthSessionService(ref.watch(secureStorageProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(googleSignInServiceProvider),
  ),
);

// ── Use cases ──────────────────────────────────────────────────────────────────
final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
);

final googleLoginUseCaseProvider = Provider<GoogleLoginUseCase>(
  (ref) => GoogleLoginUseCase(ref.watch(authRepositoryProvider)),
);

// ── Notifier ───────────────────────────────────────────────────────────────────
final loginNotifierProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, LoginState>(
      (ref) => LoginNotifier(
        loginUseCase: ref.watch(loginUseCaseProvider),
        googleLoginUseCase: ref.watch(googleLoginUseCaseProvider),
        biometricService: ref.watch(biometricServiceProvider),
        secureStorage: ref.watch(secureStorageProvider),
        sessionService: ref.watch(authSessionServiceProvider),
        googleSignInService: ref.watch(googleSignInServiceProvider),
      ),
    );

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;
  final GoogleLoginUseCase _googleLoginUseCase;
  final BiometricService _biometricService;
  final SecureStorageService _secureStorage;
  final AuthSessionService _sessionService;
  final GoogleSignInService _googleSignInService;

  LoginNotifier({
    required LoginUseCase loginUseCase,
    required GoogleLoginUseCase googleLoginUseCase,
    required BiometricService biometricService,
    required SecureStorageService secureStorage,
    required AuthSessionService sessionService,
    required GoogleSignInService googleSignInService,
  }) : _loginUseCase = loginUseCase,
       _googleLoginUseCase = googleLoginUseCase,
       _biometricService = biometricService,
       _secureStorage = secureStorage,
       _sessionService = sessionService,
       _googleSignInService = googleSignInService,
       super(const LoginState()) {
    _checkBiometricAvailability();
  }

  // ── On init: decide whether to show biometric prompt ─────────
  Future<void> _checkBiometricAvailability() async {
    final enabled = await _secureStorage.isBiometricsEnabled();
    if (!enabled) return;

    final hasCredentials =
        (await _secureStorage.getFallbackCredentials()) != null;
    if (!hasCredentials) return;

    final available = await _biometricService.isAvailable();
    if (!available) return;

    if (mounted) {
      state = state.copyWith(showBiometricPrompt: true);
    }
  }

  // ── Normal email/password login ──────────────────────────────
  /// [askEnableBiometrics] — optional callback shown after first successful
  /// login to ask the user if they want to enable biometric quick-login.
  /// Pass `null` to skip (e.g. when called from biometric flow internally).
  Future<void> login({
    required String login,
    required String password,
    Future<bool> Function()? askEnableBiometrics,
  }) async {
    if (state.status == LoginStatus.loading) return;
    state = state.copyWith(
      status: LoginStatus.loading,
      errorMessage: null,
      activeMethod: LoginMethod.password,
    );

    final result = await _loginUseCase(
      LoginParams(
        login: login,
        password: password,
        userType: state.selectedUserType,
      ),
    );

    if (result.isLeft) {
      _failMounted(result.leftValue.message);
      return;
    }

    await _completeLogin(
      result.rightValue,
      login: login,
      password: password,
      askEnableBiometrics: askEnableBiometrics,
    );
  }

  Future<void> loginWithGoogle() async {
    if (state.status == LoginStatus.loading) return;
    state = state.copyWith(
      status: LoginStatus.loading,
      errorMessage: null,
      activeMethod: LoginMethod.google,
    );

    final result = await _googleLoginUseCase();
    if (result.isLeft) {
      final failure = result.leftValue;
      if (failure is AuthCancelledFailure) {
        if (mounted) {
          state = state.copyWith(
            status: LoginStatus.initial,
            errorMessage: null,
            activeMethod: null,
          );
        }
        return;
      }
      _failMounted(failure.message);
      return;
    }

    await _completeLogin(result.rightValue);
  }

  Future<void> _completeLogin(
    UserEntity user, {
    String? login,
    String? password,
    Future<bool> Function()? askEnableBiometrics,
  }) async {
    try {
      await _sessionService.persist(user);

      if (askEnableBiometrics != null && login != null && password != null) {
        final bioAvailable = await _biometricService.isAvailable();
        final alreadyEnabled = await _secureStorage.isBiometricsEnabled();

        if (bioAvailable && !alreadyEnabled) {
          final userAgreed = await askEnableBiometrics();
          if (userAgreed) {
            await _secureStorage.saveFallbackCredentials(
              email: login,
              password: password,
            );
            await _secureStorage.saveTokens(accessToken: user.token!);
            await _secureStorage.setBiometricsEnabled(true);
          }
        }
      }

      if (mounted) {
        state = state.copyWith(
          status: LoginStatus.success,
          user: user,
          activeMethod: null,
        );
      }
    } catch (_) {
      await _sessionService.clear();
      _failMounted('auth.login.sessionSaveFailed'.tr());
    }
  }

  // ── Biometric login ──────────────────────────────────────────
  Future<void> loginWithBiometrics() async {
    if (state.status == LoginStatus.loading) return;
    state = state.copyWith(
      status: LoginStatus.loading,
      errorMessage: null,
      activeMethod: LoginMethod.biometric,
    );

    // 1) Check if biometrics are enabled by user
    final enabled = await _secureStorage.isBiometricsEnabled();
    if (!enabled) {
      _failMounted('auth.login.biometricNoCredentials'.tr());
      return;
    }

    // 2) Check stored credentials exist
    final creds = await _secureStorage.getFallbackCredentials();
    if (creds == null) {
      await _secureStorage.clearBiometricData();
      _failMounted('auth.login.biometricNoCredentials'.tr());
      return;
    }

    // 3) Prompt device biometric (fingerprint / face)
    final result = await _biometricService.authenticate(
      reason: 'auth.login.biometricReason'.tr(),
    );

    switch (result) {
      case BiometricResult.success:
        break; // continue to API call
      case BiometricResult.notAvailable:
        _failMounted('auth.login.biometricNotAvailable'.tr());
        return;
      case BiometricResult.notEnrolled:
        _failMounted('auth.errors.noBiometricEnrolled'.tr());
        return;
      case BiometricResult.cancelled:
        if (mounted) {
          state = state.copyWith(
            status: LoginStatus.initial,
            activeMethod: null,
          );
        }
        return;
      case BiometricResult.failed:
      case BiometricResult.error:
        _failMounted('auth.login.biometricFailed'.tr());
        return;
    }

    // 4) Biometric passed → call real login API with secure credentials.
    //    Pass `null` for askEnableBiometrics so we don't re-prompt.
    if (mounted) {
      state = state.copyWith(status: LoginStatus.initial, activeMethod: null);
    }
    await login(
      login: creds.email,
      password: creds.password,
      askEnableBiometrics: null,
    );
  }

  // ── Disable biometrics (from settings) ───────────────────────
  Future<void> disableBiometrics() async {
    await _secureStorage.clearBiometricData();
    if (mounted) {
      state = state.copyWith(showBiometricPrompt: false);
    }
  }

  // ── UI helpers ───────────────────────────────────────────────
  void changeUserType(UserTypeTab type) {
    state = state.copyWith(selectedUserType: type);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void resetStatus() {
    state = state.copyWith(
      status: LoginStatus.initial,
      errorMessage: null,
      activeMethod: null,
    );
  }

  // ── Logout ───────────────────────────────────────────────────
  /// [keepBiometricData] = true → user can still quick-login with biometrics
  /// after logout. Set to false to fully wipe everything.
  Future<void> logout({bool keepBiometricData = true}) async {
    await _sessionService.clear();
    try {
      await _googleSignInService.signOut();
    } catch (_) {
      debugPrint('Google sign-out could not clear the SDK session.');
    }
    if (!keepBiometricData) {
      await _secureStorage.clearBiometricData();
    }
    // Do NOT mutate state — this notifier is autoDispose and will be disposed
    // after the widget tree navigates away.
  }

  // ── Private helper ───────────────────────────────────────────
  void _failMounted(String message) {
    if (mounted) {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: message,
        activeMethod: null,
      );
    }
  }
}
