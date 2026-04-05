import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/localStorage/cache_helper.dart';
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
  (ref) => LoginNotifier(loginUseCase: ref.watch(loginUseCaseProvider)),
);

class LoginNotifier extends StateNotifier<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginNotifier({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
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
        state = state.copyWith(status: LoginStatus.success, user: user);
      },
    );
  }

  Future<void> loginWithBiometrics() async {
    state = state.copyWith(status: LoginStatus.loading, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 800));
    state = state.copyWith(status: LoginStatus.initial);
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
}

