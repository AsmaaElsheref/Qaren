import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
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
    final colors = context.appColors;
    final errorMessage = ref.watch(
      walletDepositProvider.select((state) => state.errorMessage),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: colors.bottomSheetBackground,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXL),
          ),
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
                    color: colors.border,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              Row(
                children: [
                  Expanded(
                    child: AppText(
                      'إضافة رصيد',
                      style: AppTextStyles.title.copyWith(color: colors.textPrimary),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: colors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingM),
              const WalletAmountInput(),
              const SizedBox(height: AppDimensions.paddingM),
              const WalletQuickAmountChips(),
              if (errorMessage != null) ...[
                const SizedBox(height: AppDimensions.paddingS),
                AppText(
                  errorMessage,
                  style: AppTextStyles.caption.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: AppDimensions.paddingM),
              const WalletDepositButton(),
            ],
          ),
        ),
      ),
    );
  }
}

