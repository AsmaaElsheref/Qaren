import 'package:flutter/material.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import '../../../domain/entities/food_order_booking_entity.dart';

class FoodBookingCardContent extends StatelessWidget {
  final FoodOrderBookingEntity foodOrder;

  const FoodBookingCardContent({super.key, required this.foodOrder});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (foodOrder.itemsCount != null)
          AppText(
            '${foodOrder.itemsCount} عناصر',
            style: AppTextStyles.caption,
          ),
        if (foodOrder.deliveryAddress.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.paddingXS),
          AppText(
            foodOrder.deliveryAddress,
            style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: AppDimensions.paddingXS),
        Wrap(
          spacing: AppDimensions.paddingS,
          runSpacing: AppDimensions.paddingXS,
          children: [
            if (foodOrder.paymentMethod.isNotEmpty)
              AppText('الدفع: ${foodOrder.paymentMethod}', style: AppTextStyles.caption),
            if (foodOrder.paymentStatus.isNotEmpty)
              AppText('الحالة: ${foodOrder.paymentStatus}', style: AppTextStyles.caption),
          ],
        ),
      ],
    );
  }
}

