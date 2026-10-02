import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/easy_localization.dart';
import '../../domain/entities/register_params.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_session_provider.dart';
import 'login_providers.dart';
import 'signup_state.dart';

// ── Use cases ──────────────────────────────────────────────────────────────────
final registerUseCaseProvider = Provider<RegisterUseCase>(
  (ref) => RegisterUseCase(ref.watch(authRepositoryProvider)),
);

// ── Notifier ───────────────────────────────────────────────────────────────────
final signupNotifierProvider =
    StateNotifierProvider.autoDispose<SignupNotifier, SignupState>(
      (ref) => SignupNotifier(
        registerUseCase: ref.watch(registerUseCaseProvider),
        sessionNotifier: ref.read(authSessionProvider.notifier),
      ),
    );

class SignupNotifier extends StateNotifier<SignupState> {
  final RegisterUseCase _registerUseCase;
  final AuthSessionNotifier _sessionNotifier;

  SignupNotifier({
    required RegisterUseCase registerUseCase,
    required AuthSessionNotifier sessionNotifier,
  }) : _registerUseCase = registerUseCase,
       _sessionNotifier = sessionNotifier,
       super(const SignupState());

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
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
        imagePath: state.imagePath,
      ),
    );

    if (result.isLeft) {
      state = state.copyWith(
        status: SignupStatus.failure,
        errorMessage: result.leftValue.message,
      );
      return;
    }

    try {
      final user = result.rightValue;
      await _sessionNotifier.persistAuthenticated(user);
      if (mounted) {
        state = state.copyWith(status: SignupStatus.success, user: user);
      }
    } catch (_) {
      if (mounted) {
        state = state.copyWith(
          status: SignupStatus.failure,
          errorMessage: 'auth.login.sessionSaveFailed'.tr(),
        );
      }
    }
  }

  void setImage(String? path) {
    if (path == null) {
      state = state.copyWith(clearImage: true);
    } else {
      state = state.copyWith(imagePath: path);
    }
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
