import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/ui/widgets/AppButton.dart';
import '../food_strings.dart';

/// Full-width CTA button at the bottom of the invoice screen.
class SaveInvoiceButton extends StatelessWidget {
  const SaveInvoiceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingM,
      ),
      child: AppButton(
        label: FoodStrings.bookNow,
        icon: Icons.receipt_long_rounded,
        onTap: () {},
      ),
    );
  }
}

