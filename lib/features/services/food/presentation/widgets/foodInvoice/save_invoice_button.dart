import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/ui/widgets/AppButton.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../../../../core/ui/widgets/saudi_riyal_amount.dart';
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
    final label = 'food.comparison.orderNow'.tr();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingM,
      ),
      child: AppButton(
        label: label,
        labelWidget: amount == null
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    label,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontM,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  SaudiRiyalAmount(
                    amount: amount!.toInt().toString(),
                    style: const TextStyle(
                      fontSize: AppDimensions.fontM,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
        icon: Icons.receipt_long_rounded,
        onTap: () => _onTap(context),
      ),
    );
  }
}
