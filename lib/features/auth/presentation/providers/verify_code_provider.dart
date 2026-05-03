import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import 'login_providers.dart';
import 'verify_code_state.dart';

class VerifyCodeNotifier extends StateNotifier<VerifyCodeState> {
  final AuthRepository _repository;

  VerifyCodeNotifier(this._repository) : super(const VerifyCodeState());

  Future<void> verify(String login, String code) async {
    state = state.copyWith(status: VerifyCodeStatus.loading);

    final result = await _repository.verifyCode(login.trim(), code.trim());

    result.fold(
      (failure) => state = state.copyWith(
        status: VerifyCodeStatus.failure,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(status: VerifyCodeStatus.success),
    );
  }

  Future<void> resend(String login) async {
    state = state.copyWith(status: VerifyCodeStatus.resending);

    final result = await _repository.forgotPassword(login.trim());

    result.fold(
      (failure) => state = state.copyWith(
        status: VerifyCodeStatus.failure,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(status: VerifyCodeStatus.resendSuccess),
    );
  }

  void reset() {
    state = const VerifyCodeState();
  }
}

final verifyCodeNotifierProvider =
    StateNotifierProvider.autoDispose<VerifyCodeNotifier, VerifyCodeState>(
  (ref) => VerifyCodeNotifier(ref.watch(authRepositoryProvider)),
);

