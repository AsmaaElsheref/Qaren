import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import '../../../domain/entities/car_rental_booking_entity.dart';

class CarBookingCardContent extends StatelessWidget {
  final CarRentalBookingEntity carRental;

  const CarBookingCardContent({super.key, required this.carRental});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (carRental.offerId != null)
          AppText('رقم العرض: ${carRental.offerId}', style: AppTextStyles.caption),
        if (carRental.customerName.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.paddingXS),
          AppText('العميل: ${carRental.customerName}', style: AppTextStyles.caption),
        ],
        if (carRental.customerPhone.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.paddingXS),
          AppText('الهاتف: ${carRental.customerPhone}', style: AppTextStyles.caption),
        ],
      ],
    );
  }
}

