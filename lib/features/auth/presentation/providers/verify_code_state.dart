enum VerifyCodeStatus { idle, loading, success, failure, resending, resendSuccess }

class VerifyCodeState {
  final VerifyCodeStatus status;
  final String? errorMessage;

  const VerifyCodeState({
    this.status = VerifyCodeStatus.idle,
    this.errorMessage,
  });

  VerifyCodeState copyWith({
    VerifyCodeStatus? status,
    String? errorMessage,
  }) {
    return VerifyCodeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

