import 'package:qaren/core/localization/easy_localization.dart';

enum WalletTransactionType {
  deposit,
  payment,
  unknown;

  String get label {
    return switch (this) {
      WalletTransactionType.deposit => 'wallet.transactionType.deposit'.tr(),
      WalletTransactionType.payment => 'wallet.transactionType.payment'.tr(),
      WalletTransactionType.unknown =>
        'wallet.transactionType.transaction'.tr(),
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
