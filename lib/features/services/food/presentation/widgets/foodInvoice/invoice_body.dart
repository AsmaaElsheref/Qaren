import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/food_invoice_model.dart';
import '../../providers/food_comparison_provider.dart';
import '../foodInvoice/invoice_info_grid.dart';
import '../foodInvoice/invoice_main_card.dart';
import '../foodInvoice/invoice_route_section.dart';
import '../foodInvoice/invoice_shimmer.dart';

/// Handles loading / error / data states for the invoice body.
/// Separated to keep [FoodInvoicePage.build] purely compositional.
class InvoiceBody extends StatelessWidget {
  const InvoiceBody({
    super.key,
    required this.detailState,
    required this.locationName,
  });

  final FoodInvoiceDetailState detailState;
  final String locationName;

  @override
  Widget build(BuildContext context) {
    // ── Loading ──────────────────────────────────────────────────────────────
    if (detailState.isLoading) {
      return const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: AppDimensions.paddingS),
          child: InvoiceShimmer(),
        ),
      );
    }

    // ── Error ────────────────────────────────────────────────────────────────
    if (detailState.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Text(
            'حدث خطأ: ${detailState.error}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppDimensions.fontS,
            ),
          ),
        ),
      );
    }

    // ── Data ─────────────────────────────────────────────────────────────────
    final detail = detailState.detail;
    if (detail == null) return const SizedBox.shrink();

    final now     = DateTime.now();
    final invoice = FoodInvoiceModel(
      fromLocation: detail.partnerName,
      toLocation:   locationName.isNotEmpty ? locationName : 'موقعك',
      distance: detail.distanceKm != null
          ? '${detail.distanceKm!.toStringAsFixed(1)} كم'
          : '',
      deliveryTimeMinutes: detail.products.isNotEmpty
          ? detail.products
              .where((p) => p.prepTimeMin != null)
              .fold<int>(0, (max, p) {
                final v = int.tryParse(p.prepTimeMin!) ?? 0;
                return v > max ? v : max;
              })
          : 0,
      itemsCount: detail.matchedCount,
      orderTime:  DateFormat('hh:mm a').format(now),
      date:       DateFormat('dd/MM/yyyy').format(now),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.paddingL),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            InvoiceMainCard(
              providerName: detail.partnerName,
              logoUrl: detail.partnerLogo,
            ),
            const SizedBox(height: AppDimensions.paddingL),
            InvoiceRouteSection(
              from: invoice.fromLocation,
              to: invoice.toLocation,
              deliveryMinutes: invoice.deliveryTimeMinutes,
            ),
            const SizedBox(height: AppDimensions.paddingL),
            InvoiceInfoGrid(invoice: invoice),
          ],
        ),
      ),
    );
  }
}

