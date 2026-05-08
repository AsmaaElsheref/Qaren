import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';

import '../../domain/entities/wallet_transaction_type.dart';

class WalletTransactionIcon extends StatelessWidget {
  final WalletTransactionType type;

  const WalletTransactionIcon({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isDeposit = type == WalletTransactionType.deposit;
    final color = isDeposit ? AppColors.success : AppColors.error;
    final icon = isDeposit ? Icons.add_rounded : Icons.remove_rounded;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Icon(icon, color: color),
    );
  }
}

