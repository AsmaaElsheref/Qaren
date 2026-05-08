import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import '../../domain/entities/wallet_transaction_entity.dart';
import 'wallet_transaction_icon.dart';
import 'wallet_transaction_status_badge.dart';

class WalletTransactionCard extends StatelessWidget {
  final WalletTransactionEntity transaction;
  final String currency;

  const WalletTransactionCard({
    super.key,
    required this.transaction,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final sign = transaction.type.isPositive ? '+' : '-';
    final amountColor = transaction.type.isPositive ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WalletTransactionIcon(type: transaction.type),
          const SizedBox(width: AppDimensions.paddingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText(
                        transaction.type.label,
                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    AppText(
                      '$sign${transaction.amount.toStringAsFixed(2)} $currency',
                      style: AppTextStyles.body.copyWith(
                        color: amountColor,
                        fontWeight: FontWeight.w700,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingXS),
                WalletTransactionStatusBadge(status: transaction.status),
                if (transaction.description.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.paddingS),
                  AppText(
                    transaction.description,
                    style: AppTextStyles.bodySecondary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (transaction.referenceId != null && transaction.referenceId!.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.paddingXS),
                  AppText('المرجع: ${transaction.referenceId}', style: AppTextStyles.caption),
                ],
                if (transaction.createdAtLabel.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.paddingXS),
                  AppText(transaction.createdAtLabel, style: AppTextStyles.caption),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

