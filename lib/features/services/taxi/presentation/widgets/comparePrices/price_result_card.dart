import 'package:flutter/material.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_colors_ext.dart';
import '../../../../../../core/ui/widgets/AppButton.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../../../../core/ui/widgets/AppTextStyles.dart';
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

  static String _formatPrice(double price) {
    final rounded = double.parse(price.toStringAsFixed(2));
    return rounded == rounded.truncateToDouble()
        ? rounded.toInt().toString()
        : rounded.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: result.isBestValue
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
            if (result.isBestValue) ...[
              const BestValueBadge(),
              const SizedBox(height: AppDimensions.paddingS),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProviderIcon(imageUrl: result.icon, bgColor: result.iconBgColor),
                const SizedBox(width: AppDimensions.paddingM),
                AppInfo(result: result),
                const Spacer(),
                AppText('${_formatPrice(result.price)} ${result.currency}',
                    style: AppTextStyles.body.copyWith(color: colors.textPrimary)),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingM),
            Divider(height: 1, color: colors.divider),
            const SizedBox(height: AppDimensions.paddingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (result.distance != null)
                  EstimatedTime(distance: result.distance!)
                else
                  const Spacer(),
                AppButton(
                  height: 35,
                  width: context.screenWidth * 0.27,
                  color: AppColors.textPrimary,
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
      width: 48, height: 48,
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
      imageUrl, width: 48, height: 48, fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return _shimmer();
      },
      errorBuilder: (_, __, ___) => _fallbackIcon(),
    );
  }

  Widget _shimmer() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.08),
      child: const Center(
        child: SizedBox(
          width: 20, height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _fallbackIcon() {
    return const Icon(Icons.directions_car_rounded, color: AppColors.white, size: 26);
  }
}
