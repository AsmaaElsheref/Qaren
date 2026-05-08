import '../../domain/entities/wallet_deposit_result_entity.dart';
import 'wallet_balance_model.dart';
import 'wallet_transaction_model.dart';

class WalletDepositResponseModel extends WalletDepositResultEntity {
  const WalletDepositResponseModel({
    required super.transaction,
    required super.newBalance,
  });

  factory WalletDepositResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};
    final transaction = dataMap['transaction'];

    return WalletDepositResponseModel(
      transaction: WalletTransactionModel.fromJson(
        transaction is Map ? Map<String, dynamic>.from(transaction) : <String, dynamic>{},
      ),
      newBalance: WalletBalanceModel.parseDouble(dataMap['new_balance']) ?? 0,
    );
  }
}

