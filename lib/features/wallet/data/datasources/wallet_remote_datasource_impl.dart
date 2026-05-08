import 'package:qaren/core/network/dioHelper/dio_helper.dart';

import '../models/wallet_balance_model.dart';
import '../models/wallet_deposit_request_model.dart';
import '../models/wallet_deposit_response_model.dart';
import '../models/wallet_transactions_response_model.dart';
import 'wallet_remote_datasource.dart';

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  const WalletRemoteDataSourceImpl();

  static const String balanceEndpoint = '/api/wallet/balance';
  static const String transactionsEndpoint = '/api/wallet/transactions';
  static const String depositEndpoint = '/api/wallet/deposit';

  @override
  Future<WalletBalanceModel> getBalance() async {
    final response = await DioHelper.getData(url: balanceEndpoint);
    final body = Map<String, dynamic>.from(response.data as Map);
    final data = body['data'];
    return WalletBalanceModel.fromJson(
      data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{},
    );
  }

  @override
  Future<WalletTransactionsResponseModel> getTransactions({required int page}) async {
    final response = await DioHelper.getData(
      url: transactionsEndpoint,
      query: <String, dynamic>{'page': page},
    );
    return WalletTransactionsResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  @override
  Future<WalletDepositResponseModel> deposit(WalletDepositRequestModel request) async {
    final response = await DioHelper.postData(
      url: depositEndpoint,
      data: request.toJson(),
    );
    return WalletDepositResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}

