import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/localStorage/cache_helper.dart';
import '../../domain/entities/register_params.dart';
import '../../domain/usecases/register_usecase.dart';
import 'login_providers.dart';
import 'signup_state.dart';

// ── Use cases ──────────────────────────────────────────────────────────────────
final registerUseCaseProvider = Provider<RegisterUseCase>(
  (ref) => RegisterUseCase(ref.watch(authRepositoryProvider)),
);

// ── Notifier ───────────────────────────────────────────────────────────────────
final signupNotifierProvider =
    StateNotifierProvider.autoDispose<SignupNotifier, SignupState>(
  (ref) => SignupNotifier(registerUseCase: ref.watch(registerUseCaseProvider)),
);

class SignupNotifier extends StateNotifier<SignupState> {
  final RegisterUseCase _registerUseCase;

  SignupNotifier({required RegisterUseCase registerUseCase})
      : _registerUseCase = registerUseCase,
        super(const SignupState());

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
  }) async {
    state = state.copyWith(status: SignupStatus.loading, errorMessage: null);

    final result = await _registerUseCase(
      RegisterParams(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        gender: state.selectedGender,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: SignupStatus.failure,
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
        state = state.copyWith(status: SignupStatus.success, user: user);
      },
    );
  }

  void selectGender(String gender) {
    state = state.copyWith(selectedGender: gender);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }

  void resetStatus() {
    state = state.copyWith(status: SignupStatus.initial, errorMessage: null);
  }
}

