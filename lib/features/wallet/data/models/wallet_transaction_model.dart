import '../../domain/entities/wallet_transaction_entity.dart';
import '../../domain/entities/wallet_transaction_status.dart';
import '../../domain/entities/wallet_transaction_type.dart';
import 'wallet_balance_model.dart';

class WalletTransactionModel extends WalletTransactionEntity {
  const WalletTransactionModel({
    required super.id,
    required super.amount,
    required super.type,
    required super.status,
    required super.description,
    required super.referenceId,
    required super.createdAt,
    required super.createdAtLabel,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    final reference = json['reference_id'];
    return WalletTransactionModel(
      id: WalletBalanceModel.parseInt(json['id']) ?? 0,
      amount: WalletBalanceModel.parseDouble(json['amount']) ?? 0,
      type: WalletTransactionType.fromApi(json['type'] as String?),
      status: WalletTransactionStatus.fromApi(json['status'] as String?),
      description: json['description'] as String? ?? '',
      referenceId: reference == null ? null : reference.toString(),
      createdAt: json['created_at'] as String? ?? '',
      createdAtLabel: WalletBalanceModel.formatDate(json['created_at'] as String?),
    );
  }
}

