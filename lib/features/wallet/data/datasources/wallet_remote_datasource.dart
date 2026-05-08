import '../models/wallet_balance_model.dart';
import '../models/wallet_deposit_request_model.dart';
import '../models/wallet_deposit_response_model.dart';
import '../models/wallet_transactions_response_model.dart';

abstract class WalletRemoteDataSource {
  Future<WalletBalanceModel> getBalance();

  Future<WalletTransactionsResponseModel> getTransactions({required int page});

  Future<WalletDepositResponseModel> deposit(WalletDepositRequestModel request);
}

