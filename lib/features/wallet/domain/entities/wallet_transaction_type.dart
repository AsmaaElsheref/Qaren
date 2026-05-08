enum WalletTransactionType {
  deposit,
  payment,
  unknown;

  String get label {
    return switch (this) {
      WalletTransactionType.deposit => 'إيداع',
      WalletTransactionType.payment => 'دفع',
      WalletTransactionType.unknown => 'معاملة',
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

