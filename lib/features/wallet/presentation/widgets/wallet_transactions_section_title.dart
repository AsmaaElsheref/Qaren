import 'package:flutter/material.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

class WalletTransactionsSectionTitle extends StatelessWidget {
  const WalletTransactionsSectionTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppText('آخر المعاملات', style: AppTextStyles.title);
  }
}

