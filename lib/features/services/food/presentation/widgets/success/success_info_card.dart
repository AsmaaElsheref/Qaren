import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../data/models/food_booking_response.dart';
import '../../food_strings.dart';
import '../../providers/food_providers.dart';

class SuccessInfoCard extends ConsumerWidget {
  const SuccessInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FoodBookingResponse? result =
        ref.watch(foodBookingResultProvider);
    if (result == null) return const SizedBox.shrink();

    final partnerName = ref.watch(
      selectedProviderForBookingProvider.select((p) => p?.name ?? ''),
    );
    final colors = context.appColors;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _row(FoodStrings.bookingNumberLabel, result.bookingNumber,color: colors.textPrimary),
          if (partnerName.isNotEmpty)
            _row(FoodStrings.restaurantSection, partnerName,color: colors.textPrimary),
          _row(FoodStrings.paymentMethodLabel, _paymentLabel(result),color: colors.textPrimary),
          _row(
            FoodStrings.totalLabel,
            '${result.totalPrice.toInt()} ${result.currency}',
            highlight: true
          ),
          if (result.deliveryAddress.isNotEmpty)
            _row(FoodStrings.deliverySection, result.deliveryAddress,color: colors.textPrimary),
          if (result.estimatedDeliveryMinutes != null)
            _row(
              FoodStrings.estimatedDelivery, '${result.estimatedDeliveryMinutes} ${FoodStrings.minutes}',color: colors.textPrimary
            ),
        ],
      ),
    );
  }

  static String _paymentLabel(FoodBookingResponse r) {
    switch (r.paymentMethod) {
      case 'cash':
        return FoodStrings.paymentCash;
      default:
        return r.paymentMethod;
    }
  }

  Widget _row(String label, String value, {bool highlight = false,color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AppText(
              label,
              secondary: true,
              style: const TextStyle(fontSize: AppDimensions.fontS),
            ),
          ),
          Expanded(
            flex: 3,
            child: AppText(
              value,
              maxLines: 2,
              style: TextStyle(
                fontSize: AppDimensions.fontS,
                fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
                color: highlight ? AppColors.primary : color,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

