import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import '../../../domain/entities/booking_entity.dart';
import '../history/booking_status_badge.dart';

class BookingDetailsHeaderCard extends StatelessWidget {
  final BookingEntity booking;

  const BookingDetailsHeaderCard({super.key, required this.booking});

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
          Row(
            children: [
              Expanded(
                child: AppText(
                  booking.bookingReference.isEmpty ? '#${booking.id}' : booking.bookingReference,
                  style: AppTextStyles.title,
                ),
              ),
              BookingStatusBadge(status: booking.status, label: booking.statusLabel),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingS),
          AppText(booking.serviceType.cardLabel, style: AppTextStyles.bodySecondary),
          if (booking.bookedAtLabel.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.paddingXS),
            AppText(booking.bookedAtLabel, style: AppTextStyles.caption),
          ],
          if (booking.providerSlug.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.paddingXS),
            AppText(booking.providerSlug, style: AppTextStyles.caption),
          ],
        ],
      ),
    );
  }
}

