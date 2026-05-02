import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/ui/widgets/AppButton.dart';
import '../../food_strings.dart';
import '../../pages/checkoutPage/checkout_page.dart';

/// Full-width CTA button at the bottom of the invoice screen.
///
/// Navigates to the checkout screen — the actual booking submission
/// happens there.
class SaveInvoiceButton extends StatelessWidget {
  const SaveInvoiceButton({super.key, this.amount});

  final double? amount;

  void _onTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CheckoutPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = amount == null
        ? FoodStrings.orderNow
        : '${FoodStrings.orderNow} ${amount!.toInt()} ${FoodStrings.Rial}';
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingM,
      ),
      child: AppButton(
        label: label,
        icon: Icons.receipt_long_rounded,
        onTap: () => _onTap(context),
      ),
    );
  }
}

