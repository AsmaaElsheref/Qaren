import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppButton.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../../domain/entities/food_provider_model.dart';
import '../food_strings.dart';
import 'food_best_value_badge.dart';

/// A single provider comparison card.
/// Shows: badge (if best value), provider icon + name + tag + rating,
/// price, estimated delivery time, divider, and CTA button.
class FoodProviderCard extends StatelessWidget {
  const FoodProviderCard({
    super.key,
    required this.provider,
    required this.onBook,
  });

  final FoodProviderModel provider;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBook,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: provider.isBestValue
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
              : Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            children: [
              if (provider.isBestValue) ...[
                const FoodBestValueBadge(),
                const SizedBox(height: AppDimensions.paddingS),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius:
                      BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: const Icon(
                      Icons.rocket_launch_rounded,
                      color: AppColors.textHint,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingM),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        provider.name,
                        style: const TextStyle(
                          fontSize: AppDimensions.fontM,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 13, color: Color(0xFFFFC107)),
                          const SizedBox(width: 2),
                          AppText(
                            provider.rating.toStringAsFixed(1),
                            secondary: true,
                            style: const TextStyle(
                                fontSize: AppDimensions.fontXS),
                          ),
                          const SizedBox(width: 6),
                          const AppText(
                            '·',
                            style: TextStyle(color: AppColors.textHint),
                          ),
                          const SizedBox(width: 6),
                          AppText(
                            provider.tag,
                            secondary: true,
                            style: const TextStyle(
                                fontSize: AppDimensions.fontXS),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppText(
                              '${provider.price.toInt()}',
                              style: const TextStyle(
                                fontSize: AppDimensions.fontXXL,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const AppText(
                              FoodStrings.currencyFull,
                              secondary: true,
                              style: TextStyle(fontSize: AppDimensions.fontXS),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingM),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: AppDimensions.paddingM),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const AppText(
                        FoodStrings.estimatedPrice,
                        secondary: true,
                        style: TextStyle(fontSize: AppDimensions.fontXS),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          AppText(
                            '${provider.deliveryTimeMinutes} ${FoodStrings.minutes}',
                            secondary: true,
                            style: const TextStyle(
                              fontSize: AppDimensions.fontXS,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  AppButton(
                    height: 35,
                    width: 120,
                    color: AppColors.black,
                    radius: 10,
                    removeShadow: true,
                    label: FoodStrings.bookNow,
                    icon: Icons.arrow_forward_rounded,
                    onTap: onBook,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}