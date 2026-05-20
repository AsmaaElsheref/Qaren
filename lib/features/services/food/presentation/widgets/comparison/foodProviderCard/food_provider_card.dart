import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_colors_ext.dart';
import '../../../../../../../core/ui/widgets/AppButton.dart';
import '../../../../../../../core/ui/widgets/AppText.dart';
import '../../../../../../../core/ui/widgets/AppTextStyles.dart';
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
    final colors = context.appColors;
    return GestureDetector(
      onTap: onBook,
      child: Container(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: _isPartialMatch
              ? Border.all(color: const Color(0xFFFF9500).withValues(alpha: 0.4))
              : provider.isBestValue
                  ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
                  : Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
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
                  FoodProviderImage(provider: provider),
                  const SizedBox(width: AppDimensions.paddingM),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        provider.name,
                        style: AppTextStyles.body.copyWith(
                          fontSize: AppDimensions.fontM,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (provider.rating != null) ...[
                            const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFFC107)),
                            const SizedBox(width: 2),
                            AppText(
                              provider.rating!.toStringAsFixed(1),
                              secondary: true,
                              style: TextStyle(fontSize: AppDimensions.fontXS, color: colors.textSecondary),
                            ),
                            const SizedBox(width: 6),
                            AppText('·', style: TextStyle(color: colors.textMuted)),
                            const SizedBox(width: 6),
                          ],
                          if (provider.tag.isNotEmpty)
                            AppText(
                              provider.tag,
                              secondary: true,
                              style: TextStyle(fontSize: AppDimensions.fontXS, color: colors.textSecondary),
                            ),
                          if (provider.isVerified) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.verified_rounded, size: 14, color: AppColors.primary),
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
                              style: AppTextStyles.headline.copyWith(
                                fontSize: AppDimensions.fontXXL,
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            AppText(
                              FoodStrings.currencyFull,
                              secondary: true,
                              style: TextStyle(
                                fontSize: AppDimensions.fontXS,
                                color: colors.textSecondary,
                              ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (_isPartialMatch ? AppColors.secondary : AppColors.primary)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    ),
                    child: AppText(
                      _isPartialMatch
                          ? FoodStrings.partialCoverage(provider.matchedCount, provider.totalRequested)
                          : FoodStrings.fullMatchLabel,
                      style: TextStyle(
                        fontSize: AppDimensions.fontXS,
                        fontWeight: FontWeight.w700,
                        color: _isPartialMatch ? AppColors.secondary : AppColors.primary,
                      ),
                    ),
                  ),
                ),
                if (provider.productsPreview.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.paddingS),
                  AppText(
                    FoodStrings.availableItems,
                    secondary: true,
                    style: TextStyle(
                      fontSize: AppDimensions.fontXS,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
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
                              const Icon(Icons.check_circle_rounded, size: 12, color: AppColors.primary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: AppText(
                                  p.name,
                                  style: TextStyle(
                                    fontSize: AppDimensions.fontXS,
                                    color: colors.textPrimary,
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
              Divider(height: 1, color: colors.divider),
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
                          style: TextStyle(fontSize: AppDimensions.fontXS, color: colors.textSecondary),
                        ),
                      if (provider.deliveryTimeMinutes > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time_rounded, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            AppText(
                              '${provider.deliveryTimeMinutes} ${FoodStrings.minutes}',
                              secondary: true,
                              style: TextStyle(
                                fontSize: AppDimensions.fontXS,
                                color: colors.textPrimary,
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
                          style: TextStyle(fontSize: AppDimensions.fontXS, color: colors.textSecondary),
                        ),
                    ],
                  ),
                  const Spacer(),
                  AppButton(
                    height: 35,
                    width: 120,
                    color: AppColors.textPrimary,
                    radius: 10,
                    removeShadow: true,
                    label: _isPartialMatch ? FoodStrings.orderAvailable : FoodStrings.orderNow,
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

