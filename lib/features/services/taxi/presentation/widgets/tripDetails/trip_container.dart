import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/localization/easy_localization.dart';
import 'package:qaren/core/localization/localized_formatters.dart';
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
  static String _distanceToMinutes(BuildContext context, String? raw) {
    if (raw == null || raw.isEmpty) return '—';
    final cleaned = raw.replaceAll(RegExp(r'[^0-9.]'), '');
    final km = double.tryParse(cleaned);
    if (km == null || km <= 0) return '—';
    final minutes = (km / 30 * 60).round().clamp(1, 9999);
    return 'taxi.route.durationValue'.tr(
      namedArgs: {'duration': LocalizedFormatters.number(context, minutes)},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final details = ref.watch(offerDetailsProvider.select((s) => s.details));

    // Distance comes from the compare-prices result (PriceResult.distance).
    final distance = ref.watch(
      comparePricesProvider.select((s) {
        // Find the selected offer by offerId matching details.
        if (s.results.isEmpty) return null;
        try {
          return s.results.firstWhere((r) => r.id == details?.offerId).distance;
        } catch (_) {
          return s.results.first.distance;
        }
      }),
    );

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
                title: 'taxi.tripDetails.date'.tr(),
                value: LocalizedFormatters.date(context, DateTime.now()),
              ),
              RideInfoItem(
                title: 'taxi.tripDetails.arrival'.tr(),
                value: _distanceToMinutes(context, distance),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
