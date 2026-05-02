import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../domain/entities/food_provider_model.dart';
import '../../food_strings.dart';
import '../../providers/food_providers.dart';

/// Restaurant header card on the checkout screen.
///
/// Watches only [selectedProviderForBookingProvider] so unrelated state
/// changes (notes, items qty, etc.) don't rebuild it.
class CheckoutRestaurantSection extends ConsumerWidget {
  const CheckoutRestaurantSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FoodProviderModel? partner =
        ref.watch(selectedProviderForBookingProvider);
    if (partner == null) return const SizedBox.shrink();

    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  partner.name,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontM,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const AppText(
                  FoodStrings.foodDeliveryService,
                  secondary: true,
                  style: TextStyle(fontSize: AppDimensions.fontXS),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

