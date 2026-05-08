import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';

import '../../domain/entities/wallet_balance_entity.dart';
import '../../domain/entities/wallet_deposit_result_entity.dart';
import '../../domain/entities/wallet_transactions_page_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_datasource.dart';
import '../models/wallet_deposit_request_model.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  const WalletRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, WalletBalanceEntity>> getBalance() async {
    try {
      final balance = await remoteDataSource.getBalance();
      return Either.rightOf(balance);
    } on Failure catch (failure) {
      return Either.leftOf(failure);
    } catch (error) {
      return Either.leftOf(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, WalletTransactionsPageEntity>> getTransactions({
    required int page,
  }) async {
    try {
      final transactions = await remoteDataSource.getTransactions(page: page);
      return Either.rightOf(transactions);
    } on Failure catch (failure) {
      return Either.leftOf(failure);
    } catch (error) {
      return Either.leftOf(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, WalletDepositResultEntity>> deposit({
    required double amount,
  }) async {
    try {
      final result = await remoteDataSource.deposit(
        WalletDepositRequestModel(amount: amount),
      );
      return Either.rightOf(result);
    } on Failure catch (failure) {
      return Either.leftOf(failure);
    } catch (error) {
      return Either.leftOf(ServerFailure(error.toString()));
    }
  }
}

