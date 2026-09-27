enum WalletTransactionStatus {
  completed,
  pending,
  failed,
  unknown;

  String get localizationKey {
    return switch (this) {
      WalletTransactionStatus.completed => 'wallet.transactionStatus.completed',
      WalletTransactionStatus.pending => 'wallet.transactionStatus.pending',
      WalletTransactionStatus.failed => 'wallet.transactionStatus.failed',
      WalletTransactionStatus.unknown => 'wallet.transactionStatus.unknown',
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
