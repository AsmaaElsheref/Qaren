import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import '../../../domain/entities/food_order_booking_entity.dart';

class FoodBookingDetailsSection extends StatelessWidget {
  final FoodOrderBookingEntity foodOrder;

  const FoodBookingDetailsSection({super.key, required this.foodOrder});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final notAvailable = 'common.notAvailable'.tr();
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
            'bookings.details.foodTitle'.tr(),
            style: AppTextStyles.title,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          AppText(
            'bookings.details.foodAddress'.tr(
              namedArgs: {
                'value': foodOrder.deliveryAddress.isEmpty
                    ? notAvailable
                    : foodOrder.deliveryAddress,
              },
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          AppText(
            'bookings.details.foodItemsCount'.tr(
              namedArgs: {'value': '${foodOrder.itemsCount ?? 0}'},
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          AppText(
            'bookings.details.foodPaymentMethod'.tr(
              namedArgs: {
                'value': foodOrder.paymentMethod.isEmpty
                    ? notAvailable
                    : foodOrder.paymentMethod,
              },
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          AppText(
            'bookings.details.foodPaymentStatus'.tr(
              namedArgs: {
                'value': foodOrder.paymentStatus.isEmpty
                    ? notAvailable
                    : foodOrder.paymentStatus,
              },
            ),
          ),
          if (foodOrder.customerNotes.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.paddingS),
            AppText(
              'bookings.details.foodNotes'.tr(
                namedArgs: {'value': foodOrder.customerNotes},
              ),
            ),
          ],
        ],
      ),
    );
  }
}
