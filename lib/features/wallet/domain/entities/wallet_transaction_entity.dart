import 'package:equatable/equatable.dart';

import 'wallet_transaction_status.dart';
import 'wallet_transaction_type.dart';

class WalletTransactionEntity extends Equatable {
  final int id;
  final double amount;
  final WalletTransactionType type;
  final WalletTransactionStatus status;
  final String description;
  final String? referenceId;
  final String createdAt;
  final String createdAtLabel;

  const WalletTransactionEntity({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.description,
    required this.referenceId,
    required this.createdAt,
    required this.createdAtLabel,
  });

  @override
  List<Object?> get props => [
        id,
        amount,
        type,
        status,
        description,
        referenceId,
        createdAt,
        createdAtLabel,
      ];
}

