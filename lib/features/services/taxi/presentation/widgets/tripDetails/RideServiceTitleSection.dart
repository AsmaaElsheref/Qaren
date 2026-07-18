import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/localization/easy_localization.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import '../../providers/offerDetailsProvider/offer_details_provider.dart';

class RideServiceTitleSection extends ConsumerWidget {
  const RideServiceTitleSection({super.key, required this.serviceName});

  /// Fallback name passed from the parent (e.g. providerName from compare list).
  final String serviceName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(offerDetailsProvider.select((s) => s.details));

    // Prefer the real car name from the API; fall back to the passed serviceName.
    final displayName = (details?.name?.isNotEmpty ?? false)
        ? details!.name!
        : serviceName;

    // Show car type/category as the badge label, or default.
    final badgeLabel = _resolveCategory(details?.type, details?.category);
    final colors = context.appColors;
    return Column(
      children: [
        Text(
          displayName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F5F1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            badgeLabel,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F9D8B),
            ),
          ),
        ),
      ],
    );
  }

  static String _resolveCategory(String? type, String? category) {
    final raw = category ?? type ?? '';
    if (raw.isEmpty) return 'taxi.rideType.default'.tr();
    // Map common English API values to localized labels.
    switch (raw.toLowerCase()) {
      case 'economy':
        return 'taxi.rideType.economy'.tr();
      case 'compact':
        return 'taxi.rideType.compact'.tr();
      case 'standard':
        return 'taxi.rideType.standard'.tr();
      case 'fullsize':
      case 'full_size':
        return 'taxi.rideType.fullSize'.tr();
      case 'suv':
        return 'taxi.rideType.suv'.tr();
      case 'luxury':
        return 'taxi.rideType.luxury'.tr();
      case 'van':
        return 'taxi.rideType.van'.tr();
      case 'minivan':
        return 'taxi.rideType.minivan'.tr();
      default:
        return raw;
    }
  }
}
