import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../food_strings.dart';
import 'invoice_logo_fallback.dart';

/// Main provider card in the invoice: logo + name + "خدمة توصيل طعام" tag.
class InvoiceMainCard extends StatelessWidget {
  const InvoiceMainCard({
    super.key,
    required this.providerName,
    this.logoUrl,
  });

  final String providerName;
  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Provider logo
        Container(
          width: 64,
          height: 64,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          child: logoUrl != null
              ? CachedNetworkImage(
                  imageUrl: logoUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const InvoiceLogoFallback(),
                  errorWidget: (_, __, ___) => const InvoiceLogoFallback(),
                )
              : const InvoiceLogoFallback(),
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

