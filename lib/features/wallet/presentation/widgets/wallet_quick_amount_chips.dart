import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';

import '../providers/wallet_deposit_provider.dart';

class WalletQuickAmountChips extends ConsumerWidget {
  final List<double> amounts;

  const WalletQuickAmountChips({
    super.key,
    this.amounts = const [50, 100, 200, 500],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final selectedAmount = ref.watch(walletDepositProvider.select((s) => s.amount));

    return Wrap(
      spacing: AppDimensions.paddingS,
      runSpacing: AppDimensions.paddingS,
      children: amounts.map((amount) {
        final label = amount.toStringAsFixed(0);
        final isSelected = selectedAmount == label;
        return ChoiceChip(
          selected: isSelected,
          label: AppText(label),
          selectedColor: AppColors.primary.withValues(alpha: 0.12),
          backgroundColor: colors.inputBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            side: BorderSide(color: isSelected ? AppColors.primary : colors.border),
          ),
          onSelected: (_) => ref.read(walletDepositProvider.notifier).selectQuickAmount(amount),
        );
      }).toList(growable: false),
    );
  }
}
