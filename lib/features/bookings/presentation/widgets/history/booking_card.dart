import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import '../../../domain/entities/booking_entity.dart';
import '../../../domain/entities/booking_service_type.dart';
import 'booking_price_text.dart';
import 'booking_status_badge.dart';
import 'car_booking_card_content.dart';
import 'food_booking_card_content.dart';

class BookingCard extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback onTap;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icon = switch (booking.serviceType) {
      BookingServiceType.foodOrder => Icons.restaurant_rounded,
      BookingServiceType.carRental => Icons.directions_car_rounded,
      BookingServiceType.all || BookingServiceType.unknown => Icons.receipt_long_rounded,
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Icon(icon, color: AppColors.primary),
                ),
                const SizedBox(width: AppDimensions.paddingS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        booking.bookingReference.isEmpty ? '#${booking.id}' : booking.bookingReference,
                        style: AppTextStyles.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      AppText(
                        booking.serviceType.cardLabel,
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                BookingStatusBadge(status: booking.status, label: booking.statusLabel),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingM),
            Row(
              children: [
                Expanded(
                  child: AppText(
                    booking.providerSlug.isEmpty ? 'مزود الخدمة' : booking.providerSlug,
                    style: AppTextStyles.bodySecondary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                BookingPriceText(pricing: booking.pricing),
              ],
            ),
            if (booking.bookedAtLabel.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.paddingXS),
              AppText(booking.bookedAtLabel, style: AppTextStyles.caption),
            ],
            const Divider(height: AppDimensions.paddingL, color: AppColors.border),
            if (booking.foodOrder != null)
              FoodBookingCardContent(foodOrder: booking.foodOrder!)
            else if (booking.carRental != null)
              CarBookingCardContent(carRental: booking.carRental!)
            else
              AppText('تفاصيل الطلب متاحة داخل صفحة التفاصيل', style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

