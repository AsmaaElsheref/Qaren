import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'invoice_info_cell_shimmer.dart';

/// Shimmer skeleton that mimics the layout of [FoodInvoicePage] while data loads.
class InvoiceShimmer extends StatelessWidget {
  const InvoiceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          ),
          child: Column(
            children: [
              // Logo placeholder
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              // Name placeholder
              Container(
                width: 140,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingS),
              // Tag placeholder
              Container(
                width: 90,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),
              // Route section placeholder
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusL),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),
              // Info grid placeholder — 2x2
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingL),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: InvoiceInfoCellShimmer()),
                        Expanded(child: InvoiceInfoCellShimmer()),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.paddingL),
                    Row(
                      children: [
                        Expanded(child: InvoiceInfoCellShimmer()),
                        Expanded(child: InvoiceInfoCellShimmer()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

