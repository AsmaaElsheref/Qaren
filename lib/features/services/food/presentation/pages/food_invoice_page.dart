import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../providers/food_providers.dart';
import '../widgets/invoice_header.dart';
import '../widgets/invoice_info_grid.dart';
import '../widgets/invoice_main_card.dart';
import '../widgets/invoice_route_section.dart';
import '../widgets/save_invoice_button.dart';

/// Order invoice / receipt screen — "فاتورة الطلب".
/// Composes widgets only. Zero business logic.
class FoodInvoicePage extends ConsumerWidget {
  const FoodInvoicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoice = ref.watch(foodInvoiceProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.paddingS),
                const InvoiceHeader(),
                const SizedBox(height: AppDimensions.paddingM),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingL,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusXL),
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
                          // Provider card
                          InvoiceMainCard(
                            providerName: invoice.provider.name,
                          ),
                          const SizedBox(height: AppDimensions.paddingL),

                          // Route section
                          InvoiceRouteSection(
                            from: invoice.fromLocation,
                            to: invoice.toLocation,
                            deliveryMinutes: invoice.deliveryTimeMinutes,
                          ),
                          const SizedBox(height: AppDimensions.paddingL),

                          // Info grid
                          InvoiceInfoGrid(invoice: invoice),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Bottom CTA ──
                const SaveInvoiceButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

