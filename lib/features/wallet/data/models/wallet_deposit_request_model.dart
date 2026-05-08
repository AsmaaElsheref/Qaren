class WalletDepositRequestModel {
  final double amount;

  const WalletDepositRequestModel({required this.amount});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'amount': amount};
  }
}

