import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

class WalletBalanceAmount extends StatelessWidget {
  final double amount;
  final String currency;

  const WalletBalanceAmount({
    super.key,
    required this.amount,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return AppText(
      '${amount.toStringAsFixed(2)} $currency',
      style: AppTextStyles.headline.copyWith(
        color: AppColors.white,
        fontSize: 32,
      ),
      textDirection: TextDirection.ltr,
    );
  }
}

