import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import '../../../domain/entities/car_rental_booking_entity.dart';

class CarBookingDetailsSection extends StatelessWidget {
  final CarRentalBookingEntity carRental;

  const CarBookingDetailsSection({super.key, required this.carRental});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
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
          const AppText('تفاصيل تأجير السيارة', style: AppTextStyles.title),
          const SizedBox(height: AppDimensions.paddingM),
          AppText('رقم العرض: ${carRental.offerId ?? 'غير متاح'}'),
          const SizedBox(height: AppDimensions.paddingS),
          AppText('اسم العميل: ${carRental.customerName.isEmpty ? 'غير متاح' : carRental.customerName}'),
          const SizedBox(height: AppDimensions.paddingS),
          AppText('رقم الهاتف: ${carRental.customerPhone.isEmpty ? 'غير متاح' : carRental.customerPhone}'),
        ],
      ),
    );
  }
}

