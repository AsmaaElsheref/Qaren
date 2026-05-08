import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import '../providers/wallet_provider.dart';
import 'wallet_balance_amount.dart';

class WalletBalanceCard extends ConsumerWidget {
  final VoidCallback onAddBalance;

  const WalletBalanceCard({
    super.key,
    required this.onAddBalance,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(walletProvider.select((state) => state.balance));
    final amount = balance?.balance ?? 0;
    final currency = balance?.currency ?? 'EGP';
    final updatedAtLabel = balance?.updatedAtLabel ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'رصيد المحفظة',
            style: AppTextStyles.bodySecondary.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          WalletBalanceAmount(amount: amount, currency: currency),
          if (updatedAtLabel.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.paddingS),
            AppText(
              'آخر تحديث: $updatedAtLabel',
              style: AppTextStyles.caption.copyWith(color: AppColors.white),
            ),
          ],
          const SizedBox(height: AppDimensions.paddingL),
          // SizedBox(
          //   height: 44,
          //   child: ElevatedButton.icon(
          //     onPressed: onAddBalance,
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: AppColors.white,
          //       foregroundColor: AppColors.primary,
          //       elevation: 0,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          //       ),
          //     ),
          //     icon: const Icon(Icons.add_rounded, color: AppColors.primary),
          //     label: const AppText(
          //       'إضافة رصيد',
          //       style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
