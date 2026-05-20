import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../food_strings.dart';
import '../../providers/food_providers.dart';

class CheckoutPaymentSection extends ConsumerWidget {
  const CheckoutPaymentSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final method = ref.watch(checkoutPaymentMethodProvider);
    final colors = context.appColors;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            FoodStrings.paymentSection,
            style: TextStyle(
              fontSize: AppDimensions.fontM,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            onTap: () => ref.read(checkoutPaymentMethodProvider.notifier).state = 'cash',
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingS),
              decoration: BoxDecoration(
                color: method == 'cash'
                    ? AppColors.primary.withValues(alpha: 0.08)
                    : colors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(
                  color: method == 'cash'
                      ? AppColors.primary
                      : colors.border,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.payments_rounded, color: AppColors.primary),
                  const SizedBox(width: AppDimensions.paddingS),
                  Expanded(
                    child: AppText(
                      FoodStrings.paymentCash,
                      style: TextStyle(
                        fontSize: AppDimensions.fontS,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    method == 'cash'
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

