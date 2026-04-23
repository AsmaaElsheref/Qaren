import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/food_invoice_model.dart';
import '../../food_strings.dart';
import 'invoice_info_cell.dart';

/// 2x2 info grid in the invoice: date, order time, delivery duration, items.
class InvoiceInfoGrid extends StatelessWidget {
  const InvoiceInfoGrid({super.key, required this.invoice});

  final FoodInvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InvoiceInfoCell(
                  label: FoodStrings.dateLabel,
                  value: invoice.date,
                ),
              ),
              Expanded(
                child: InvoiceInfoCell(
                  label: FoodStrings.orderTimeLabel,
                  value: invoice.orderTime,
                  crossAlign: CrossAxisAlignment.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Row(
            children: [
              Expanded(
                child: InvoiceInfoCell(
                  label: FoodStrings.itemsLabel,
                  value: '${invoice.itemsCount} ${FoodStrings.orderUnit}',
                ),
              ),
              Expanded(
                child: InvoiceInfoCell(
                  label: FoodStrings.deliveryDuration,
                  value: '${invoice.deliveryTimeMinutes} ${FoodStrings.minutes}',
                  valueColor: AppColors.primary,
                  crossAlign: CrossAxisAlignment.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

