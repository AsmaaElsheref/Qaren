enum ForgotPasswordStatus { idle, loading, success, failure }

class ForgotPasswordState {
  final ForgotPasswordStatus status;
  final String? errorMessage;
  final String? login;

  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.idle,
    this.errorMessage,
    this.login,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    String? errorMessage,
    String? login,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      login: login ?? this.login,
    );
  }
}

