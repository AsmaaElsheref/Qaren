import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';

import '../providers/wallet_provider.dart';
import 'wallet_empty_state.dart';
import 'wallet_error_state.dart';
import 'wallet_transaction_card.dart';

class WalletTransactionsList extends ConsumerWidget {
  const WalletTransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(walletProvider.select((state) => state.transactions));
    final currency = ref.watch(walletProvider.select((state) => state.currency));
    final errorMessage = ref.watch(walletProvider.select((state) => state.errorMessage));
    final isLoadingMore = ref.watch(walletProvider.select((state) => state.isLoadingMore));

    if (transactions.isEmpty && errorMessage != null) {
      return WalletErrorState(
        message: errorMessage,
        onRetry: () => ref.read(walletProvider.notifier).loadInitial(),
      );
    }

    if (transactions.isEmpty) return const WalletEmptyState();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == transactions.length) {
          return const Padding(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return WalletTransactionCard(
          transaction: transactions[index],
          currency: currency,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: AppDimensions.paddingM),
      itemCount: transactions.length + (isLoadingMore ? 1 : 0),
    );
  }
}

