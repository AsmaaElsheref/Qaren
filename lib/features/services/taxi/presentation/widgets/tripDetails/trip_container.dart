import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../providers/comparePricesProvider/compare_prices_provider.dart';
import '../../providers/offerDetailsProvider/offer_details_provider.dart';
import 'RideInfoItem.dart';
import 'RideRouteCard.dart';
import 'RideServiceIconCard.dart';
import 'RideServiceTitleSection.dart';

class TripContainer extends ConsumerWidget {
  const TripContainer({super.key, required this.serviceName});

  final String serviceName;

  /// Converts a distance string like "12.5 km" or "12.5" to minutes.
  /// Assumes average city speed of 30 km/h → 2 min per km.
  static String _distanceToMinutes(String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    final cleaned = raw.replaceAll(RegExp(r'[^0-9.]'), '');
    final km = double.tryParse(cleaned);
    if (km == null || km <= 0) return '—';
    final minutes = (km / 30 * 60).round().clamp(1, 9999);
    return '$minutes دقيقة';
  }

  static String _formatPrice(double? price, String currency) {
    if (price == null) return '—';
    final rounded = double.parse(price.toStringAsFixed(2));
    final formatted = rounded == rounded.truncateToDouble()
        ? rounded.toInt().toString()
        : rounded.toStringAsFixed(2);
    return '$formatted $currency';
  }
  static String _todayLabel() {
    final now = DateTime.now();
    final d = now.day.toString().padLeft(2, '0');
    final m = now.month.toString().padLeft(2, '0');
    final y = now.year.toString();
    return '$d/$m/$y';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final details = ref.watch(
      offerDetailsProvider.select((s) => s.details),
    );

    // Distance comes from the compare-prices result (PriceResult.distance).
    final distance = ref.watch(
      comparePricesProvider.select((s) {
        // Find the selected offer by offerId matching details.
        if (s.results.isEmpty) return null;
        try {
          return s.results
              .firstWhere((r) => r.id == details?.offerId)
              .distance;
        } catch (_) {
          return s.results.first.distance;
        }
      }),
    );

    final price = details?.totalPrice ?? details?.pricePerDay;
    final currency = details?.currency ?? 'SAR';
    final priceLabel = _formatPrice(price, currency);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        children: [
          const RideServiceIconCard(),
          const SizedBox(height: 18),
          RideServiceTitleSection(serviceName: serviceName),
          const SizedBox(height: 36),
          const RideRouteCard(),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RideInfoItem(
                title: 'التاريخ',
                value: _todayLabel(),
              ),
              RideInfoItem(
                title: 'الوصول',
                value: _distanceToMinutes(distance),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


