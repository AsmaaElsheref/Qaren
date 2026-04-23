import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/ui/widgets/AppButton.dart';
import '../../../../../../../core/ui/widgets/AppText.dart';
import '../../../../domain/entities/food_provider_model.dart';
import '../../../food_strings.dart';
import '../food_best_value_badge.dart';
import 'foodProviderImage/food_provider_image.dart';

/// A single provider comparison card.
class FoodProviderCard extends StatelessWidget {
  const FoodProviderCard({
    super.key,
    required this.provider,
    required this.onBook,
  });

  final FoodProviderModel provider;
  final VoidCallback onBook;

  bool get _isFullMatch =>
      provider.totalRequested > 0 &&
      provider.matchedCount >= provider.totalRequested;

  bool get _isPartialMatch =>
      provider.totalRequested > 0 &&
      provider.matchedCount > 0 &&
      provider.matchedCount < provider.totalRequested;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBook,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: _isPartialMatch
              ? Border.all(color: const Color(0xFFFF9500).withValues(alpha: 0.4))
              : provider.isBestValue
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
                  FoodProviderImage(provider: provider,),
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
                          if (provider.rating != null) ...[
                            const Icon(Icons.star_rounded,
                                size: 13, color: Color(0xFFFFC107)),
                            const SizedBox(width: 2),
                            AppText(
                              provider.rating!.toStringAsFixed(1),
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
                          ],
                          if (provider.tag.isNotEmpty)
                            AppText(
                              provider.tag,
                              secondary: true,
                              style: const TextStyle(
                                  fontSize: AppDimensions.fontXS),
                            ),
                          if (provider.isVerified) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.verified_rounded,
                                size: 14, color: AppColors.primary),
                          ],
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                              style:
                                  TextStyle(fontSize: AppDimensions.fontXS),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingM),
              if (_isFullMatch || _isPartialMatch) ...[
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (_isPartialMatch
                              ? AppColors.secondary
                              : AppColors.primary)
                          .withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusS),
                    ),
                    child: AppText(
                      _isPartialMatch
                          ? FoodStrings.partialCoverage(
                              provider.matchedCount,
                              provider.totalRequested,
                            )
                          : FoodStrings.fullMatchLabel,
                      style: TextStyle(
                        fontSize: AppDimensions.fontXS,
                        fontWeight: FontWeight.w700,
                        color: _isPartialMatch
                            ? AppColors.secondary
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ),
                if (provider.productsPreview.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.paddingS),
                  AppText(
                    FoodStrings.availableItems,
                    secondary: true,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontXS,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final p in provider.productsPreview)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 12,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: AppText(
                                  p.name,
                                  style: const TextStyle(
                                    fontSize: AppDimensions.fontXS,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: AppDimensions.paddingM),
              ],
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: AppDimensions.paddingM),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (provider.distanceKm != null)
                        AppText(
                          '${provider.distanceKm!.toStringAsFixed(1)} كم',
                          secondary: true,
                          style: const TextStyle(
                              fontSize: AppDimensions.fontXS),
                        ),
                      if (provider.deliveryTimeMinutes > 0)
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
                      if (provider.deliveryFee != null)
                        AppText(
                          provider.deliveryFee == 0
                              ? 'توصيل مجاني'
                              : 'توصيل ${provider.deliveryFee!.toInt()} ${provider.currency}',
                          secondary: true,
                          style: const TextStyle(
                              fontSize: AppDimensions.fontXS),
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
                    label: _isPartialMatch
                        ? FoodStrings.orderAvailable
                        : FoodStrings.orderNow,
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

