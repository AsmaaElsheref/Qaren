import 'package:flutter/material.dart';
import 'package:qaren/core/localization/localized_formatters.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';
import 'package:qaren/core/ui/widgets/saudi_riyal_amount.dart';

class WalletBalanceAmount extends StatelessWidget {
  final double amount;

  const WalletBalanceAmount({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    return SaudiRiyalAmount(
      amount: LocalizedFormatters.number(context, amount, decimals: 2),
      style: AppTextStyles.headline.copyWith(
        color: AppColors.white,
        fontSize: 32,
      ),
      symbolSize: 27,
    );
  }
}
