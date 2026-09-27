import 'package:qaren/core/localization/easy_localization.dart';
import 'package:qaren/core/localization/localized_formatters.dart';
import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';
import 'package:qaren/core/ui/widgets/saudi_riyal_amount.dart';

import '../../../domain/entities/booking_pricing_entity.dart';

class BookingPriceText extends StatelessWidget {
  final BookingPricingEntity pricing;

  const BookingPriceText({super.key, required this.pricing});

  @override
  Widget build(BuildContext context) {
    if (!pricing.canShowTotal) {
      return AppText(
        'bookings.price.unavailable'.tr(),
        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
      );
    }

    return SaudiRiyalAmount(
      amount: LocalizedFormatters.number(
        context,
        pricing.totalPrice!,
        decimals: 2,
      ),
      style: AppTextStyles.title.copyWith(color: AppColors.primary),
    );
  }
}
