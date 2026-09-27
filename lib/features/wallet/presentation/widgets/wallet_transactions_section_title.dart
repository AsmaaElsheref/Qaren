import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

class WalletTransactionsSectionTitle extends StatelessWidget {
  const WalletTransactionsSectionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return AppText(
      context.tr('wallet.transactions.title'),
      style: AppTextStyles.title,
    );
  }
}
