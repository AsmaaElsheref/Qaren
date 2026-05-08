import 'wallet_balance_model.dart';

class WalletPaginationMetaModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const WalletPaginationMetaModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory WalletPaginationMetaModel.fromJson(Map<String, dynamic>? json) {
    return WalletPaginationMetaModel(
      currentPage: WalletBalanceModel.parseInt(json?['current_page']) ?? 1,
      lastPage: WalletBalanceModel.parseInt(json?['last_page']) ?? 1,
      perPage: WalletBalanceModel.parseInt(json?['per_page']) ?? 15,
      total: WalletBalanceModel.parseInt(json?['total']) ?? 0,
    );
  }
}

