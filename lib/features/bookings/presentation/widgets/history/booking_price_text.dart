import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import '../../../domain/entities/booking_pricing_entity.dart';

class BookingPriceText extends StatelessWidget {
  final BookingPricingEntity pricing;

  const BookingPriceText({super.key, required this.pricing});

  @override
  Widget build(BuildContext context) {
    if (!pricing.canShowTotal) {
      return AppText(
        'السعر غير متاح',
        style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
      );
    }

    return AppText(
      '${pricing.totalPrice!.toStringAsFixed(2)} ${pricing.currency}',
      style: AppTextStyles.title.copyWith(color: AppColors.primary),
      textDirection: TextDirection.ltr,
    );
  }
}

