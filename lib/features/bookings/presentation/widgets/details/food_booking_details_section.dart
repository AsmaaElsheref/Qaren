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
          const AppText('تفاصيل طلب الطعام', style: AppTextStyles.title),
          const SizedBox(height: AppDimensions.paddingM),
          AppText('العنوان: ${foodOrder.deliveryAddress.isEmpty ? 'غير متاح' : foodOrder.deliveryAddress}'),
          const SizedBox(height: AppDimensions.paddingS),
          AppText('عدد العناصر: ${foodOrder.itemsCount ?? 0}'),
          const SizedBox(height: AppDimensions.paddingS),
          AppText('طريقة الدفع: ${foodOrder.paymentMethod.isEmpty ? 'غير متاح' : foodOrder.paymentMethod}'),
          const SizedBox(height: AppDimensions.paddingS),
          AppText('حالة الدفع: ${foodOrder.paymentStatus.isEmpty ? 'غير متاح' : foodOrder.paymentStatus}'),
          if (foodOrder.customerNotes.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.paddingS),
            AppText('ملاحظات: ${foodOrder.customerNotes}'),
          ],
        ],
      ),
    );
  }
}

