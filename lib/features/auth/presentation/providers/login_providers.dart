import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/localStorage/cache_helper.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/login_params.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

// ── Data layer ─────────────────────────────────────────────────────────────────
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => const AuthRemoteDataSourceImpl(),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider)),
);

// ── Use cases ──────────────────────────────────────────────────────────────────
final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => LoginUseCase(ref.watch(authRepositoryProvider)),
);

// ── Notifier ───────────────────────────────────────────────────────────────────
final loginNotifierProvider =
    StateNotifierProvider.autoDispose<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(
    loginUseCase: ref.watch(loginUseCaseProvider),
    biometricService: ref.watch(biometricServiceProvider),
    secureStorage: ref.watch(secureStorageProvider),
  ),
);

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;
  final BiometricService _biometricService;
  final SecureStorageService _secureStorage;

  LoginNotifier({
    required LoginUseCase loginUseCase,
    required BiometricService biometricService,
    required SecureStorageService secureStorage,
  })  : _loginUseCase = loginUseCase,
        _biometricService = biometricService,
        _secureStorage = secureStorage,
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
    state = state.copyWith(status: LoginStatus.loading, errorMessage: null);

    final result = await _loginUseCase(
      LoginParams(
        login: login,
        password: password,
        userType: state.selectedUserType,
      ),
    );

    result.fold(
      (failure) {
        if (mounted) {
          state = state.copyWith(
            status: LoginStatus.failure,
            errorMessage: failure.message,
          );
        }
      },
      (user) async {
        // Persist session (non-sensitive) via CacheHelper
        if (user.token != null) {
          await CacheHelper.saveData(
            key: AppConstants.token,
            value: user.token!,
          );
        }
        await CacheHelper.saveData(
          key: AppConstants.userName,
          value: user.name,
        );
        await CacheHelper.saveData(
          key: AppConstants.userPhone,
          value: user.phone,
        );

        // Ask user to enable biometric login (only on manual login)
        if (askEnableBiometrics != null) {
          final bioAvailable = await _biometricService.isAvailable();
          final alreadyEnabled = await _secureStorage.isBiometricsEnabled();

          if (bioAvailable && !alreadyEnabled) {
            final userAgreed = await askEnableBiometrics();
            if (userAgreed) {
              // Store credentials securely for biometric quick-login.
              // The backend does NOT support refresh tokens, so we store
              // encrypted email/password via flutter_secure_storage as the
              // safest possible fallback. These are AES-encrypted behind
              // Android Keystore / iOS Keychain — NOT plaintext.
              await _secureStorage.saveFallbackCredentials(
                email: login,
                password: password,
              );
              if (user.token != null) {
                await _secureStorage.saveTokens(accessToken: user.token!);
              }
              await _secureStorage.setBiometricsEnabled(true);
            }
          }
        }

        if (mounted) {
          state = state.copyWith(status: LoginStatus.success, user: user);
        }
      },
    );
  }

  // ── Biometric login ──────────────────────────────────────────
  Future<void> loginWithBiometrics() async {
    state = state.copyWith(status: LoginStatus.loading, errorMessage: null);

    // 1) Check if biometrics are enabled by user
    final enabled = await _secureStorage.isBiometricsEnabled();
    if (!enabled) {
      _failMounted(AppStrings.biometricNoCredentials);
      return;
    }

    // 2) Check stored credentials exist
    final creds = await _secureStorage.getFallbackCredentials();
    if (creds == null) {
      await _secureStorage.clearBiometricData();
      _failMounted(AppStrings.biometricNoCredentials);
      return;
    }

    // 3) Prompt device biometric (fingerprint / face)
    final result = await _biometricService.authenticate(
      reason: AppStrings.biometricReason,
    );

    switch (result) {
      case BiometricResult.success:
        break; // continue to API call
      case BiometricResult.notAvailable:
        _failMounted(AppStrings.biometricNotAvailable);
        return;
      case BiometricResult.notEnrolled:
        _failMounted('لم يتم تسجيل أي بصمة على الجهاز');
        return;
      case BiometricResult.cancelled:
        if (mounted) state = state.copyWith(status: LoginStatus.initial);
        return;
      case BiometricResult.failed:
      case BiometricResult.error:
        _failMounted(AppStrings.biometricFailed);
        return;
    }

    // 4) Biometric passed → call real login API with secure credentials.
    //    Pass `null` for askEnableBiometrics so we don't re-prompt.
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
    state = state.copyWith(status: LoginStatus.initial, errorMessage: null);
  }

  // ── Logout ───────────────────────────────────────────────────
  /// [keepBiometricData] = true → user can still quick-login with biometrics
  /// after logout. Set to false to fully wipe everything.
  Future<void> logout({bool keepBiometricData = true}) async {
    await CacheHelper.clearAll();
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
      );
    }
  }
}
