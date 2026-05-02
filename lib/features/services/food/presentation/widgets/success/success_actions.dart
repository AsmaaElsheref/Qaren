import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppButton.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../food_strings.dart';
import '../../pages/foodInvoicePage/food_invoice_page.dart';
import '../../providers/food_providers.dart';

/// Bottom CTA pair — view invoice / back to home.
///
/// Stateless and only depends on Navigator + Riverpod refs at tap time,
/// so it never rebuilds with state changes.
class SuccessActions extends ConsumerWidget {
  const SuccessActions({super.key});

  void _onBackHome(BuildContext context, WidgetRef ref) {
    // Reset transient flow state so a future order starts clean.
    ref.read(foodBookingProvider.notifier).reset();
    ref.read(foodCartProvider.notifier).clear();
    ref.read(checkoutNotesProvider.notifier).state = '';

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Column(
        children: [
          AppButton(
            label: FoodStrings.backToHome,
            icon: Icons.home,
            onTap: () => _onBackHome(context, ref),
          ),
          SizedBox(height: AppDimensions.paddingXL,)
        ],
      ),
    );
  }
}

