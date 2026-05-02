import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../food_strings.dart';
import '../../providers/food_providers.dart';

/// Delivery address + estimated time section. Watches only the address /
/// partner so it doesn't rebuild on unrelated state changes.
class CheckoutDeliverySection extends ConsumerWidget {
  const CheckoutDeliverySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.watch(foodSelectedLocationNameProvider);
    final partner = ref.watch(selectedProviderForBookingProvider);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            FoodStrings.deliverySection,
            style: TextStyle(
              fontSize: AppDimensions.fontM,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Row(
            children: [
              const Icon(Icons.location_on_outlined,
                  color: AppColors.primary, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: AppText(
                  address.isNotEmpty ? address : 'لم يتم تحديد العنوان',
                  style: const TextStyle(
                    fontSize: AppDimensions.fontS,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (partner != null && partner.deliveryTimeMinutes > 0) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 6),
                AppText(
                  '${FoodStrings.estimatedDelivery}: '
                  '${partner.deliveryTimeMinutes} ${FoodStrings.minutes}',
                  secondary: true,
                  style: const TextStyle(fontSize: AppDimensions.fontXS),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

