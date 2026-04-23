import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../providers/food_providers.dart';
import '../../widgets/foodInvoice/invoice_body.dart';
import '../../widgets/foodInvoice/invoice_header.dart';
import '../../widgets/foodInvoice/save_invoice_button.dart';

/// Order invoice / receipt screen — "فاتورة الطلب".
/// Purely compositional — watches two providers and delegates all rendering
/// to [InvoiceBody] and [InvoiceHeader].
class FoodInvoicePage extends ConsumerWidget {
  const FoodInvoicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState  = ref.watch(foodInvoiceDetailProvider);
    final locationName = ref.watch(foodSelectedLocationNameProvider);

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
                  child: InvoiceBody(
                    detailState: detailState,
                    locationName: locationName,
                  ),
                ),
                SaveInvoiceButton(amount: detailState.detail?.grandTotal,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}