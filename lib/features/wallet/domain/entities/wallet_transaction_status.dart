enum WalletTransactionStatus {
  completed,
  pending,
  failed,
  unknown;

  String get label {
    return switch (this) {
      WalletTransactionStatus.completed => 'مكتملة',
      WalletTransactionStatus.pending => 'قيد الانتظار',
      WalletTransactionStatus.failed => 'فشلت',
      WalletTransactionStatus.unknown => 'غير معروفة',
    };
  }

  static WalletTransactionStatus fromApi(String? value) {
    return switch (value) {
      'completed' => WalletTransactionStatus.completed,
      'pending' => WalletTransactionStatus.pending,
      'failed' => WalletTransactionStatus.failed,
      _ => WalletTransactionStatus.unknown,
    };
  }
}

