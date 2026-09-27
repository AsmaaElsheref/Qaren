import 'package:qaren/core/localization/easy_localization.dart';
import 'package:qaren/core/localization/localized_formatters.dart';
import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';
import 'package:qaren/core/ui/widgets/saudi_riyal_amount.dart';

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
          _priceRow(
            context,
            'bookings.details.subtotalLabel'.tr(),
            pricing.subtotal,
          ),
          const SizedBox(height: AppDimensions.paddingS),
          _priceRow(
            context,
            'bookings.details.deliveryFeeLabel'.tr(),
            pricing.deliveryFee,
          ),
          const Divider(
            height: AppDimensions.paddingL,
            color: AppColors.border,
          ),
          _priceRow(
            context,
            'bookings.details.totalLabel'.tr(),
            pricing.totalPrice,
            style: AppTextStyles.title.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
    BuildContext context,
    String label,
    double? value, {
    TextStyle? style,
  }) {
    if (value == null) {
      return AppText(
        '$label ${'bookings.price.unavailable'.tr()}',
        style: style,
      );
    }
    return Wrap(
      spacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppText(label, style: style),
        SaudiRiyalAmount(
          amount: LocalizedFormatters.number(context, value, decimals: 2),
          style: style,
        ),
      ],
    );
  }
}
