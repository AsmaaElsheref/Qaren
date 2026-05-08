import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';

import '../entities/wallet_balance_entity.dart';
import '../entities/wallet_deposit_result_entity.dart';
import '../entities/wallet_transactions_page_entity.dart';

abstract class WalletRepository {
  Future<Either<Failure, WalletBalanceEntity>> getBalance();

  Future<Either<Failure, WalletTransactionsPageEntity>> getTransactions({
    required int page,
  });

  Future<Either<Failure, WalletDepositResultEntity>> deposit({
    required double amount,
  });
}

