import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';

import '../entities/wallet_deposit_result_entity.dart';
import '../repositories/wallet_repository.dart';

class DepositWalletAmountUseCase {
  final WalletRepository repository;

  const DepositWalletAmountUseCase(this.repository);

  Future<Either<Failure, WalletDepositResultEntity>> call({required double amount}) {
    return repository.deposit(amount: amount);
  }
}

