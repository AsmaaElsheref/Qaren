import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';

import '../providers/wallet_provider.dart';
import '../widgets/wallet_app_bar.dart';
import '../widgets/wallet_balance_card.dart';
import '../widgets/wallet_deposit_sheet.dart';
import '../widgets/wallet_loading_skeleton.dart';
import '../widgets/wallet_transactions_list.dart';
import '../widgets/wallet_transactions_section_title.dart';

class WalletPage extends ConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInitialLoading = ref.watch(walletProvider.select((state) => state.isInitialLoading));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // appBar: const WalletAppBar(),
        body: SafeArea(
          child: isInitialLoading
              ? const WalletLoadingSkeleton()
              : RefreshIndicator(
                  onRefresh: () => ref.read(walletProvider.notifier).refresh(),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 220) {
                        ref.read(walletProvider.notifier).loadMore();
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(AppDimensions.paddingM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WalletBalanceCard(
                            onAddBalance: () => showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const WalletDepositSheet(),
                            ),
                          ),
                          const SizedBox(height: AppDimensions.paddingL),
                          const WalletTransactionsSectionTitle(),
                          const SizedBox(height: AppDimensions.paddingM),
                          const WalletTransactionsList(),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
