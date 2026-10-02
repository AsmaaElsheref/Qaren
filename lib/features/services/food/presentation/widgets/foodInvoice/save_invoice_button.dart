import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/ui/widgets/AppButton.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../../../../core/ui/widgets/saudi_riyal_amount.dart';
import '../../pages/checkoutPage/checkout_page.dart';
import '../../../../../auth/presentation/guards/guest_access_guard.dart';

class SaveInvoiceButton extends ConsumerWidget {
  const SaveInvoiceButton({super.key, this.amount});

  final double? amount;

  Future<void> _onTap(BuildContext context, WidgetRef ref) async {
    if (!await GuestAccessGuard.ensureAuthenticated(
      context: context,
      ref: ref,
    )) {
      return;
    }
    if (!context.mounted) return;
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CheckoutPage()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        onTap: () => _onTap(context, ref),
      ),
    );
  }
}
