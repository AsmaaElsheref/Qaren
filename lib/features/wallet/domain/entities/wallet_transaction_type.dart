enum WalletTransactionType {
  deposit,
  payment,
  unknown;

  String get localizationKey {
    return switch (this) {
      WalletTransactionType.deposit => 'wallet.transactionType.deposit',
      WalletTransactionType.payment => 'wallet.transactionType.payment',
      WalletTransactionType.unknown => 'wallet.transactionType.transaction',
    };
  }

  bool get isPositive => this == WalletTransactionType.deposit;

  static WalletTransactionType fromApi(String? value) {
    return switch (value) {
      'deposit' => WalletTransactionType.deposit,
      'payment' => WalletTransactionType.payment,
      _ => WalletTransactionType.unknown,
    };
  }
}
