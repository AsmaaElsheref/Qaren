import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/localStorage/cache_helper.dart';
import '../../../../core/services/biometric_service.dart';
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

// ── Services ───────────────────────────────────────────────────────────────────
final biometricServiceProvider = Provider<BiometricService>(
  (ref) => BiometricServiceImpl(),
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
  ),
);

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;
  final BiometricService _biometricService;

  LoginNotifier({
    required LoginUseCase loginUseCase,
    required BiometricService biometricService,
  })  : _loginUseCase = loginUseCase,
        _biometricService = biometricService,
        super(const LoginState());

  Future<void> login({
    required String login,
    required String password,
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
      (failure) => state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: failure.message,
      ),
      (user) async {
        if (user.token != null) {
          await CacheHelper.saveData(
            key: AppConstants.token,
            value: user.token!,
          );
        }
        await CacheHelper.saveData(key: AppConstants.userName, value: user.name);
        await CacheHelper.saveData(key: AppConstants.userPhone, value: user.phone);

        // Save credentials for biometric login next time.
        await CacheHelper.saveData(
          key: AppConstants.biometricEmail,
          value: login,
        );
        await CacheHelper.saveData(
          key: AppConstants.biometricPassword,
          value: password,
        );
        await CacheHelper.saveData(
          key: AppConstants.biometricEnabled,
          value: true,
        );

        state = state.copyWith(status: LoginStatus.success, user: user);
      },
    );
  }

  Future<void> loginWithBiometrics() async {
    // 1. Check device support
    final isAvailable = await _biometricService.isAvailable();
    if (!isAvailable) {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: AppStrings.biometricNotAvailable,
      );
      return;
    }

    // 2. Check if credentials were previously saved
    final savedEmail =
        CacheHelper.getData(key: AppConstants.biometricEmail) as String?;
    final savedPassword =
        CacheHelper.getData(key: AppConstants.biometricPassword) as String?;
    final enabled =
        CacheHelper.getData(key: AppConstants.biometricEnabled) as bool? ??
            false;

    if (!enabled ||
        savedEmail == null ||
        savedEmail.isEmpty ||
        savedPassword == null ||
        savedPassword.isEmpty) {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: AppStrings.biometricNoCredentials,
      );
      return;
    }

    // 3. Prompt device biometric (fingerprint / face)
    final authenticated = await _biometricService.authenticate(
      reason: AppStrings.biometricReason,
    );

    if (!authenticated) {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: AppStrings.biometricFailed,
      );
      return;
    }

    // 4. Biometric passed → call real login API with saved credentials
    await login(login: savedEmail, password: savedPassword);
  }

  void changeUserType(UserTypeTab type) {
    state = state.copyWith(selectedUserType: type);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void resetStatus() {
    state = state.copyWith(status: LoginStatus.initial, errorMessage: null);
  }

  Future<void> logout() async {
    await CacheHelper.clearAll();
    // Do NOT mutate state here — this notifier is autoDispose and may already
    // be disposed by the time the async gap completes, causing a Bad-state crash.
  }
}

