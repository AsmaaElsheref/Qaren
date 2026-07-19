import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';

import '../../../domain/entities/booking_service_type.dart';

class BookingDetailsActions extends StatelessWidget {
  final BookingServiceType serviceType;

  const BookingDetailsActions({super.key, required this.serviceType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (serviceType == BookingServiceType.foodOrder) ...[
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeight,
            child: ElevatedButton(
              onPressed: null,
              child: AppText('bookings.details.reorder'.tr()),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
        ],
        SizedBox(
          width: double.infinity,
          height: AppDimensions.buttonHeight,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, color: AppColors.primary),
            label: AppText('bookings.details.share'.tr()),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        SizedBox(
          width: double.infinity,
          height: AppDimensions.buttonHeight,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText('bookings.details.back'.tr()),
          ),
        ),
      ],
    );
  }
}
