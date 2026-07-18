import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import '../../../domain/entities/booking_pricing_entity.dart';

class BookingDetailsPricingCard extends StatelessWidget {
  final BookingPricingEntity pricing;

  const BookingDetailsPricingCard({super.key, required this.pricing});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (!pricing.available) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.border),
        ),
        child: AppText(
          'bookings.price.unavailable'.tr(),
          style: AppTextStyles.title,
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'bookings.details.priceSummary'.tr(),
            style: AppTextStyles.title,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          AppText(
            'bookings.details.subtotal'.tr(
              namedArgs: {'price': formatPrice(pricing.subtotal)},
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: AppDimensions.paddingS),
          AppText(
            'bookings.details.deliveryFee'.tr(
              namedArgs: {'price': formatPrice(pricing.deliveryFee)},
            ),
            textDirection: TextDirection.rtl,
          ),
          const Divider(
            height: AppDimensions.paddingL,
            color: AppColors.border,
          ),
          AppText(
            'bookings.details.total'.tr(
              namedArgs: {'price': formatPrice(pricing.totalPrice)},
            ),
            style: AppTextStyles.title.copyWith(color: AppColors.primary),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  String formatPrice(double? value) {
    if (value == null) return 'bookings.price.unavailable'.tr();
    return '${value.toStringAsFixed(2)} ${pricing.currency}';
  }
}
