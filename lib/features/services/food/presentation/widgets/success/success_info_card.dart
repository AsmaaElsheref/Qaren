import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../../../../core/ui/widgets/saudi_riyal_amount.dart';
import '../../../data/models/food_booking_response.dart';
import '../../providers/food_providers.dart';

class SuccessInfoCard extends ConsumerWidget {
  const SuccessInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FoodBookingResponse? result = ref.watch(foodBookingResultProvider);
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
          _row(
            'food.success.bookingNumber'.tr(),
            result.bookingNumber,
            color: colors.textPrimary,
          ),
          if (partnerName.isNotEmpty)
            _row(
              'food.checkout.restaurantSection'.tr(),
              partnerName,
              color: colors.textPrimary,
            ),
          _row(
            'food.success.paymentMethod'.tr(),
            _paymentLabel(result),
            color: colors.textPrimary,
          ),
          _row(
            'food.checkout.total'.tr(),
            null,
            valueWidget: SaudiRiyalAmount(
              amount: result.totalPrice.toInt().toString(),
              style: const TextStyle(
                fontSize: AppDimensions.fontS,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
            highlight: true,
          ),
          if (result.deliveryAddress.isNotEmpty)
            _row(
              'food.checkout.deliverySection'.tr(),
              result.deliveryAddress,
              color: colors.textPrimary,
            ),
          if (result.estimatedDeliveryMinutes != null)
            _row(
              'food.checkout.estimatedDelivery'.tr(),
              '${result.estimatedDeliveryMinutes} ${'food.comparison.minutes'.tr()}',
              color: colors.textPrimary,
            ),
        ],
      ),
    );
  }

  static String _paymentLabel(FoodBookingResponse r) {
    switch (r.paymentMethod) {
      case 'cash':
        return 'food.checkout.paymentCash'.tr();
      default:
        return r.paymentMethod;
    }
  }

  Widget _row(
    String label,
    String? value, {
    Widget? valueWidget,
    bool highlight = false,
    color,
  }) {
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
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child:
                  valueWidget ??
                  AppText(
                    value!,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: AppDimensions.fontS,
                      fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
                      color: highlight ? AppColors.primary : color,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
