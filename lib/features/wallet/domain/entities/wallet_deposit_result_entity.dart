import 'package:equatable/equatable.dart';

import 'wallet_transaction_entity.dart';

class WalletDepositResultEntity extends Equatable {
  final WalletTransactionEntity transaction;
  final double newBalance;

  const WalletDepositResultEntity({
    required this.transaction,
    required this.newBalance,
  });

  @override
  List<Object?> get props => [transaction, newBalance];
}

