import 'package:flutter/material.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppButton.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../data/models/comparePrices/compare_prices_model.dart';
import 'app_info.dart';
import 'best_value_badge.dart';
import 'estimated_time.dart';

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
            if (result.isBestValue) ...[
              const BestValueBadge(),
              const SizedBox(height: AppDimensions.paddingS),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProviderIcon(
                  imageUrl: result.icon,
                  bgColor: result.iconBgColor,
                ),
                const SizedBox(width: AppDimensions.paddingM),
                AppInfo(result: result),
                const Spacer(),
                AppText('${result.price} ريال'),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingM),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: AppDimensions.paddingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (result.distance != null)
                  EstimatedTime(distance: result.distance!),
                AppButton(
                  height: 35,
                  width: context.screenWidth * 0.27,
                  color: AppColors.black,
                  radius: 10,
                  removeShadow: true,
                  label: 'احجز الآن',
                  icon: Icons.arrow_forward_rounded,
                  onTap: onBook,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private widget ────────────────────────────────────────────────────────────

/// Renders the provider/car image from a URL.
/// Falls back to a car icon when the URL is empty, null, or fails to load.
class _ProviderIcon extends StatelessWidget {
  const _ProviderIcon({required this.imageUrl, required this.bgColor});

  final String imageUrl;
  final Color bgColor;

  bool get _hasValidUrl =>
      imageUrl.isNotEmpty &&
      (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      clipBehavior: Clip.antiAlias,
      child: _hasValidUrl ? _networkImage() : _fallbackIcon(),
    );
  }

  Widget _networkImage() {
    return Image.network(
      imageUrl,
      width: 48,
      height: 48,
      fit: BoxFit.cover,
      // Show a shimmer-style placeholder while loading
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return _shimmer();
      },
      // Fall back to the car icon if the URL is broken
      errorBuilder: (_, __, ___) => _fallbackIcon(),
    );
  }

  Widget _shimmer() {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _fallbackIcon() {
    return const Icon(
      Icons.directions_car_rounded,
      color: AppColors.white,
      size: 26,
    );
  }
}

