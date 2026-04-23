import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../food_strings.dart';
import '../../providers/food_cart_provider.dart';
import '../summary_row.dart';

/// Bottom order summary section: subtotal, tax, and total rows.
/// Rebuilds only when subtotal/tax/total change via granular providers.
class OrderSummarySection extends ConsumerWidget {
  const OrderSummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtotal = ref.watch(foodCartSubtotalProvider);
    final tax = ref.watch(foodCartTaxProvider);
    final total = ref.watch(foodCartTotalProvider);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.paddingM,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SummaryRow(
            label: FoodStrings.subtotal,
            value: '${subtotal.toStringAsFixed(2)} ${FoodStrings.currencyShort}',
          ),
          const SizedBox(height: AppDimensions.paddingS),
          SummaryRow(
            label: FoodStrings.taxAndFees,
            value: '${tax.toStringAsFixed(2)} ${FoodStrings.currencyShort}',
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                FoodStrings.total,
                style: const TextStyle(
                  fontSize: AppDimensions.fontL,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              AppText(
                '${total.toStringAsFixed(2)} ${FoodStrings.currencyShort}',
                style: const TextStyle(
                  fontSize: AppDimensions.fontL,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


