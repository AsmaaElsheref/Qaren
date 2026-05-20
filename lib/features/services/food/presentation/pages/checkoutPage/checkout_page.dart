import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../widgets/checkout/checkout_confirm_button.dart';
import '../../widgets/checkout/checkout_delivery_section.dart';
import '../../widgets/checkout/checkout_header.dart';
import '../../widgets/checkout/checkout_items_list.dart';
import '../../widgets/checkout/checkout_notes_input.dart';
import '../../widgets/checkout/checkout_payment_section.dart';
import '../../widgets/checkout/checkout_restaurant_section.dart';
import '../../widgets/checkout/checkout_summary_section.dart';

class CheckoutPage extends ConsumerWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const CheckoutHeader(),
                const SizedBox(height: AppDimensions.paddingS),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.paddingM,
                    ),
                    child: Column(
                      children: const [
                        CheckoutRestaurantSection(),
                        SizedBox(height: AppDimensions.paddingM),
                        CheckoutDeliverySection(),
                        SizedBox(height: AppDimensions.paddingM),
                        CheckoutItemsList(),
                        SizedBox(height: AppDimensions.paddingM),
                        CheckoutNotesInput(),
                        SizedBox(height: AppDimensions.paddingM),
                        CheckoutPaymentSection(),
                        SizedBox(height: AppDimensions.paddingM),
                        CheckoutSummarySection(),
                      ],
                    ),
                  ),
                ),
                const CheckoutConfirmButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

