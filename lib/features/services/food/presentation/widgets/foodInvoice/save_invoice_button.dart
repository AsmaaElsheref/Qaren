import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/ui/widgets/AppButton.dart';
import '../../pages/checkoutPage/checkout_page.dart';

class SaveInvoiceButton extends StatelessWidget {
  const SaveInvoiceButton({super.key, this.amount});

  final double? amount;

  void _onTap(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CheckoutPage()));
  }

  @override
  Widget build(BuildContext context) {
    final label = amount == null
        ? 'food.comparison.orderNow'.tr()
        : '${'food.comparison.orderNow'.tr()} ${amount!.toInt()} ${'food.currencyShort'.tr()}';
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
