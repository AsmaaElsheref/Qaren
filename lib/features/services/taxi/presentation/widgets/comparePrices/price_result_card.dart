import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppButton.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../data/models/comparePrices/compare_prices_model.dart';

/// A single price result card.
/// Purely presentational — receives a [PriceResult] and an [onBook] callback.
class PriceResultCard extends StatelessWidget {
  const PriceResultCard({
    super.key,
    required this.result,
    required this.onBook,
  });

  final PriceResult result;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: result.isBestValue
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
            // ── Best value badge ──────────────────────────────────────────
            if (result.isBestValue) ...[
              const _BestValueBadge(),
              const SizedBox(height: AppDimensions.paddingS),
            ],

            // ── Main row ──────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price (leading, RTL → on the right visually)
                _PriceLabel(price: result.price),

                const Spacer(),

                // App info
                _AppInfo(result: result),

                const SizedBox(width: AppDimensions.paddingM),

                // Icon
                _AppIcon(result: result),
              ],
            ),

            const SizedBox(height: AppDimensions.paddingM),

            const Divider(height: 1, color: AppColors.border),

            const SizedBox(height: AppDimensions.paddingM),

            // ── Bottom row ────────────────────────────────────────────────
            Row(
              children: [
                // Book button
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: AppButton(
                      label: 'احجز الآن',
                      icon: Icons.arrow_back_rounded,
                      onTap: onBook,
                    ),
                  ),
                ),

                const SizedBox(width: AppDimensions.paddingM),

                // Estimated time
                _EstimatedTime(minutes: result.estimatedMinutes),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

class _BestValueBadge extends StatelessWidget {
  const _BestValueBadge();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingS,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.star_rounded, size: 13, color: AppColors.white),
            SizedBox(width: 4),
            AppText(
              'الأفضل قيمة',
              style: TextStyle(
                fontSize: AppDimensions.fontXS,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceLabel extends StatelessWidget {
  const _PriceLabel({required this.price});

  final double price;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: price % 1 == 0
                    ? price.toInt().toString()
                    : price.toStringAsFixed(1),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const AppText(
          'ريال سعودي',
          secondary: true,
          style: TextStyle(fontSize: AppDimensions.fontXS),
        ),
      ],
    );
  }
}

class _AppInfo extends StatelessWidget {
  const _AppInfo({required this.result});

  final PriceResult result;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppText(
          result.appName,
          style: const TextStyle(
            fontSize: AppDimensions.fontM,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              result.rideType,
              secondary: true,
              style: const TextStyle(fontSize: AppDimensions.fontXS),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFFC107)),
            const SizedBox(width: 2),
            AppText(
              result.rating.toStringAsFixed(1),
              secondary: true,
              style: const TextStyle(fontSize: AppDimensions.fontXS),
            ),
          ],
        ),
      ],
    );
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon({required this.result});

  final PriceResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: result.iconBgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Icon(result.icon, color: result.iconColor, size: 26),
    );
  }
}

class _EstimatedTime extends StatelessWidget {
  const _EstimatedTime({required this.minutes});

  final int minutes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const AppText(
          'السعر التقديري',
          secondary: true,
          style: TextStyle(fontSize: AppDimensions.fontXS),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 13,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            AppText(
              '$minutes دقيقة',
              secondary: true,
              style: const TextStyle(fontSize: AppDimensions.fontXS),
            ),
          ],
        ),
      ],
    );
  }
}

