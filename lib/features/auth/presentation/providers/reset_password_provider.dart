import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import 'login_providers.dart';
import 'reset_password_state.dart';

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  final AuthRepository _repository;

  ResetPasswordNotifier(this._repository) : super(const ResetPasswordState());

  Future<void> resetPassword({
    required String login,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = state.copyWith(status: ResetPasswordStatus.loading);

    final result = await _repository.resetPassword(
      login.trim(),
      code.trim(),
      password,
      passwordConfirmation,
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ResetPasswordStatus.failure,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(status: ResetPasswordStatus.success),
    );
  }

  void reset() {
    state = const ResetPasswordState();
  }
}

final resetPasswordNotifierProvider =
    StateNotifierProvider.autoDispose<ResetPasswordNotifier, ResetPasswordState>(
  (ref) => ResetPasswordNotifier(ref.watch(authRepositoryProvider)),
);

