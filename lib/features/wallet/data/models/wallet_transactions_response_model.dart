import '../../domain/entities/wallet_transactions_page_entity.dart';
import 'wallet_pagination_meta_model.dart';
import 'wallet_transaction_model.dart';

class WalletTransactionsResponseModel extends WalletTransactionsPageEntity {
  const WalletTransactionsResponseModel({
    required super.transactions,
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
    required super.nextLink,
  });

  factory WalletTransactionsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? const [];
    final links = json['links'];
    final meta = WalletPaginationMetaModel.fromJson(asMap(json['meta']));

    return WalletTransactionsResponseModel(
      transactions: data
          .whereType<Map>()
          .map((item) => WalletTransactionModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false),
      currentPage: meta.currentPage,
      lastPage: meta.lastPage,
      perPage: meta.perPage,
      total: meta.total,
      nextLink: asMap(links)?['next'] as String?,
    );
  }

  static Map<String, dynamic>? asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}

