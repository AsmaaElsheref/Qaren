import 'package:equatable/equatable.dart';

import 'wallet_transaction_entity.dart';

class WalletTransactionsPageEntity extends Equatable {
  final List<WalletTransactionEntity> transactions;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final String? nextLink;

  const WalletTransactionsPageEntity({
    required this.transactions,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.nextLink,
  });

  bool get hasMore => currentPage < lastPage || (nextLink != null && nextLink!.isNotEmpty);

  @override
  List<Object?> get props => [transactions, currentPage, lastPage, perPage, total, nextLink];
}

