import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/food_invoice_model.dart';
import 'invoice_info_cell.dart';

/// 2x2 info grid in the invoice: date, order time, delivery duration, items.
class InvoiceInfoGrid extends StatelessWidget {
  const InvoiceInfoGrid({super.key, required this.invoice});

  final FoodInvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InvoiceInfoCell(
                  label: 'food.invoice.date'.tr(),
                  value: invoice.date,
                ),
              ),
              Expanded(
                child: InvoiceInfoCell(
                  label: 'food.invoice.orderTime'.tr(),
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
                  label: 'food.invoice.items'.tr(),
                  value:
                      '${invoice.itemsCount} ${'food.invoice.orderUnit'.tr()}',
                ),
              ),
              Expanded(
                child: InvoiceInfoCell(
                  label: 'food.invoice.deliveryDuration'.tr(),
                  value:
                      '${invoice.deliveryTimeMinutes} ${'food.comparison.minutes'.tr()}',
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
