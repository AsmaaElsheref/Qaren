import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../food_strings.dart';

/// Main provider card in the invoice: logo + name + "خدمة توصيل طعام" tag.
class InvoiceMainCard extends StatelessWidget {
  const InvoiceMainCard({super.key, required this.providerName});

  final String providerName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Provider icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          child: const Icon(
            Icons.delivery_dining_rounded,
            size: 30,
            color: AppColors.textHint,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingM),
        // Provider name
        AppText(
          providerName,
          style: const TextStyle(
            fontSize: AppDimensions.fontL,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        // Service tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
          child: const AppText(
            FoodStrings.foodDeliveryService,
            style: TextStyle(
              fontSize: AppDimensions.fontXS,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

