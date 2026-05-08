import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';

import '../entities/wallet_balance_entity.dart';
import '../repositories/wallet_repository.dart';

class GetWalletBalanceUseCase {
  final WalletRepository repository;

  const GetWalletBalanceUseCase(this.repository);

  Future<Either<Failure, WalletBalanceEntity>> call() {
    return repository.getBalance();
  }
}

