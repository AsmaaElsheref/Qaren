import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';

import '../entities/wallet_transactions_page_entity.dart';
import '../repositories/wallet_repository.dart';

class GetWalletTransactionsUseCase {
  final WalletRepository repository;

  const GetWalletTransactionsUseCase(this.repository);

  Future<Either<Failure, WalletTransactionsPageEntity>> call({required int page}) {
    return repository.getTransactions(page: page);
  }
}

