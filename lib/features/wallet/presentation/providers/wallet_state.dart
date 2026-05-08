import 'package:equatable/equatable.dart';

import '../../domain/entities/wallet_balance_entity.dart';
import '../../domain/entities/wallet_transaction_entity.dart';

class WalletState extends Equatable {
  final WalletBalanceEntity? balance;
  final List<WalletTransactionEntity> transactions;
  final int currentPage;
  final int lastPage;
  final bool hasMore;
  final bool isInitialLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final String? errorMessage;

  const WalletState({
    this.balance,
    this.transactions = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.hasMore = false,
    this.isInitialLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  String get currency => balance?.currency ?? 'EGP';

  bool get isEmpty => !isInitialLoading && transactions.isEmpty && errorMessage == null;

  WalletState copyWith({
    WalletBalanceEntity? balance,
    List<WalletTransactionEntity>? transactions,
    int? currentPage,
    int? lastPage,
    bool? hasMore,
    bool? isInitialLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      hasMore: hasMore ?? this.hasMore,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        balance,
        transactions,
        currentPage,
        lastPage,
        hasMore,
        isInitialLoading,
        isRefreshing,
        isLoadingMore,
        errorMessage,
      ];
}

