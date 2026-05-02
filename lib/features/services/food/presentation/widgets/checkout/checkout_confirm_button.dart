import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/ui/widgets/AppButton.dart';
import '../../food_strings.dart';
import '../../pages/successPage/success_page.dart';
import '../../providers/food_providers.dart';

/// Bottom CTA — submits the booking and navigates to the success screen.
///
/// Listens to [foodBookingIsLoadingProvider] only — typing notes etc. do
/// not rebuild it.
class CheckoutConfirmButton extends ConsumerWidget {
  const CheckoutConfirmButton({super.key});

  Future<void> _submit(BuildContext context, WidgetRef ref) async {
    final notes = ref.read(checkoutNotesProvider);
    final method = ref.read(checkoutPaymentMethodProvider);
    final coupon = ref.read(checkoutCouponProvider);

    final ok = await ref
        .read(foodBookingProvider.notifier)
        .submitForSelectedPartner(
          customerNotes: notes,
          paymentMethod: method,
          couponCode: coupon,
        );

    if (!ok || !context.mounted) {
      final err = ref.read(foodBookingErrorProvider);
      if (err != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err)),
        );
      }
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SuccessPage()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(foodBookingIsLoadingProvider);
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: AppButton(
        label: FoodStrings.confirmOrder,
        isLoading: isLoading,
        icon: Icons.check_circle_rounded,
        onTap: isLoading ? null : () => _submit(context, ref),
      ),
    );
  }
}

