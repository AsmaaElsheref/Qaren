enum ResetPasswordStatus { idle, loading, success, failure }

class ResetPasswordState {
  final ResetPasswordStatus status;
  final String? errorMessage;

  const ResetPasswordState({
    this.status = ResetPasswordStatus.idle,
    this.errorMessage,
  });

  ResetPasswordState copyWith({
    ResetPasswordStatus? status,
    String? errorMessage,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

