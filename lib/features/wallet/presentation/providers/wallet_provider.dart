import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/wallet_remote_datasource.dart';
import '../../data/datasources/wallet_remote_datasource_impl.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../domain/entities/wallet_balance_entity.dart';
import '../../domain/entities/wallet_deposit_result_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../domain/usecases/deposit_wallet_amount_usecase.dart';
import '../../domain/usecases/get_wallet_balance_usecase.dart';
import '../../domain/usecases/get_wallet_transactions_usecase.dart';
import 'wallet_state.dart';

final walletRemoteDataSourceProvider = Provider<WalletRemoteDataSource>(
  (ref) => const WalletRemoteDataSourceImpl(),
);

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => WalletRepositoryImpl(ref.watch(walletRemoteDataSourceProvider)),
);

final getWalletBalanceUseCaseProvider = Provider<GetWalletBalanceUseCase>(
  (ref) => GetWalletBalanceUseCase(ref.watch(walletRepositoryProvider)),
);

final getWalletTransactionsUseCaseProvider = Provider<GetWalletTransactionsUseCase>(
  (ref) => GetWalletTransactionsUseCase(ref.watch(walletRepositoryProvider)),
);

final depositWalletAmountUseCaseProvider = Provider<DepositWalletAmountUseCase>(
  (ref) => DepositWalletAmountUseCase(ref.watch(walletRepositoryProvider)),
);

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>(
  (ref) => WalletNotifier(
    getWalletBalanceUseCase: ref.watch(getWalletBalanceUseCaseProvider),
    getWalletTransactionsUseCase: ref.watch(getWalletTransactionsUseCaseProvider),
  )..loadInitial(),
);

class WalletNotifier extends StateNotifier<WalletState> {
  final GetWalletBalanceUseCase getWalletBalanceUseCase;
  final GetWalletTransactionsUseCase getWalletTransactionsUseCase;

  WalletNotifier({
    required this.getWalletBalanceUseCase,
    required this.getWalletTransactionsUseCase,
  }) : super(const WalletState());

  Future<void> loadInitial() async {
    state = state.copyWith(isInitialLoading: true, clearError: true);
    await Future.wait([loadBalance(), fetchTransactions(page: 1, append: false)]);
    if (!mounted) return;
    state = state.copyWith(isInitialLoading: false);
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, clearError: true);
    await Future.wait([loadBalance(), fetchTransactions(page: 1, append: false)]);
    if (!mounted) return;
    state = state.copyWith(isRefreshing: false);
  }

  Future<void> loadBalance() async {
    final result = await getWalletBalanceUseCase();
    if (!mounted) return;
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (balance) => state = state.copyWith(balance: balance, clearError: true),
    );
  }

  Future<void> fetchTransactions({required int page, required bool append}) async {
    final result = await getWalletTransactionsUseCase(page: page);
    if (!mounted) return;
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (pageData) {
        final next = append
            ? [...state.transactions, ...pageData.transactions]
            : pageData.transactions;
        state = state.copyWith(
          transactions: next,
          currentPage: pageData.currentPage,
          lastPage: pageData.lastPage,
          hasMore: pageData.hasMore,
          clearError: true,
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore || state.isInitialLoading) return;
    state = state.copyWith(isLoadingMore: true, clearError: true);
    await fetchTransactions(page: state.currentPage + 1, append: true);
    if (!mounted) return;
    state = state.copyWith(isLoadingMore: false);
  }

  void applyDepositResult(WalletDepositResultEntity result) {
    final currentBalance = state.balance;
    state = state.copyWith(
      balance: currentBalance?.copyWith(balance: result.newBalance) ??
          WalletBalanceEntity(
            id: 0,
            balance: result.newBalance,
            currency: 'EGP',
            updatedAt: result.transaction.createdAt,
            updatedAtLabel: result.transaction.createdAtLabel,
          ),
      transactions: [result.transaction, ...state.transactions],
      clearError: true,
    );
  }
}
