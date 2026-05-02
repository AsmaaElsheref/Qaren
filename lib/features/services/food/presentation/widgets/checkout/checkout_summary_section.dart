import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../food_strings.dart';
import '../../providers/food_providers.dart';

/// Order summary block (subtotal + delivery fee + total).
///
/// Watches only [checkoutSubtotalProvider] + the partner's delivery fee, so
/// it does NOT rebuild when notes/payment change.
class CheckoutSummarySection extends ConsumerWidget {
  const CheckoutSummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtotal = ref.watch(checkoutSubtotalProvider);
    final deliveryFee = ref.watch(
      selectedProviderForBookingProvider.select((p) => p?.deliveryFee ?? 0),
    );
    final total = subtotal + deliveryFee;

    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _row(FoodStrings.subtotal, subtotal),
          const SizedBox(height: 6),
          _row(FoodStrings.deliveryFeeLabel, deliveryFee),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
            child: Divider(height: 1, color: AppColors.border),
          ),
          _row(FoodStrings.totalLabel, total, isBold: true),
        ],
      ),
    );
  }

  Widget _row(String label, double amount, {bool isBold = false}) {
    final style = TextStyle(
      fontSize: isBold ? AppDimensions.fontM : AppDimensions.fontS,
      fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
      color: AppColors.textPrimary,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(label, secondary: !isBold, style: style),
        AppText('${amount.toInt()} ${FoodStrings.currencyShort}',
            style: style),
      ],
    );
  }
}

