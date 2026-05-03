import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/utils/print/custom_print.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/repositories/auth_repository.dart';
import 'forgot_password_state.dart';
import 'login_providers.dart';

class ForgotPasswordNotifier extends StateNotifier<ForgotPasswordState> {
  final AuthRepository _repository;

  ForgotPasswordNotifier(this._repository) : super(const ForgotPasswordState());

  Future<void> sendResetLink(String email) async {
    state = state.copyWith(status: ForgotPasswordStatus.loading);

    final result = await _repository.forgotPassword(email.trim());

    result.fold(
      (failure) => state = state.copyWith(
        status: ForgotPasswordStatus.failure,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: ForgotPasswordStatus.success,
        login: email.trim(),
      ),
    );
  }

  void reset() {
    state = const ForgotPasswordState();
  }
}

final forgotPasswordNotifierProvider =
    StateNotifierProvider.autoDispose<ForgotPasswordNotifier, ForgotPasswordState>(
  (ref) => ForgotPasswordNotifier(ref.watch(authRepositoryProvider)),
);

