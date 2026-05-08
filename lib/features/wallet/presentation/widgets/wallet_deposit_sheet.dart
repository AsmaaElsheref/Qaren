import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import '../providers/wallet_deposit_provider.dart';
import 'wallet_amount_input.dart';
import 'wallet_deposit_button.dart';
import 'wallet_quick_amount_chips.dart';

class WalletDepositSheet extends ConsumerWidget {
  const WalletDepositSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorMessage = ref.watch(walletDepositProvider.select((state) => state.errorMessage));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.radiusXL)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppDimensions.paddingM,
            AppDimensions.paddingM,
            AppDimensions.paddingM,
            AppDimensions.paddingM + MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              Row(
                children: [
                  const Expanded(child: AppText('إضافة رصيد', style: AppTextStyles.title)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingM),
              const WalletAmountInput(),
              const SizedBox(height: AppDimensions.paddingM),
              const WalletQuickAmountChips(),
              if (errorMessage != null && errorMessage.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.paddingM),
                AppText(
                  errorMessage,
                  style: AppTextStyles.caption.copyWith(color: AppColors.error),
                ),
              ],
              const SizedBox(height: AppDimensions.paddingL),
              const WalletDepositButton(),
              const SizedBox(height: AppDimensions.paddingS),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const AppText('إلغاء'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

