import 'package:qaren/core/localization/easy_localization.dart';

enum WalletTransactionStatus {
  completed,
  pending,
  failed,
  unknown;

  String get label {
    return switch (this) {
      WalletTransactionStatus.completed =>
        'wallet.transactionStatus.completed'.tr(),
      WalletTransactionStatus.pending =>
        'wallet.transactionStatus.pending'.tr(),
      WalletTransactionStatus.failed => 'wallet.transactionStatus.failed'.tr(),
      WalletTransactionStatus.unknown =>
        'wallet.transactionStatus.unknown'.tr(),
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
