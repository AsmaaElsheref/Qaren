import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../providers/taxi_providers.dart';

class RouteInfoCard extends ConsumerWidget {
  const RouteInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickup = ref.watch(taxiPickupLocationProvider);
    final destination = ref.watch(taxiDestinationLocationProvider);
    final sameLocation = ref.watch(taxiSameLocationProvider);

    if (pickup == null || destination == null || sameLocation) {
      return const SizedBox.shrink();
    }

    final loading = ref.watch(routeLoadingProvider);
    final hasRoutes = ref.watch(routeHasRoutesProvider);
    final errorMessage = ref.watch(routeProvider.select((s) => s.errorMessage));
    final colors = context.appColors;

    if (loading) {
      return _CardShell(
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            AppText(
              'جاري تحميل المسارات...',
              style: TextStyle(color: colors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    if (!hasRoutes) {
      if (errorMessage == null) return const SizedBox.shrink();
      return _CardShell(
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.error, size: 20),
            const SizedBox(width: AppDimensions.paddingS),
            Expanded(
              child: AppText(
                errorMessage,
                style: const TextStyle(color: AppColors.error, fontSize: 13),
              ),
            ),
          ],
        ),
      );
    }

    final distance = ref.watch(routeSelectedDistanceProvider);
    final duration = ref.watch(routeSelectedDurationProvider);
    final fee = ref.watch(routeDeliveryFeeProvider);
    final routeName = ref.watch(routeSelectedNameProvider);

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            routeName ?? 'المسار المحدد',
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          _InfoRow(
            label: 'المسافة',
            value: distance == null ? '--' : '${distance.toStringAsFixed(1)} km',
          ),
          const SizedBox(height: AppDimensions.paddingS),
          _InfoRow(
            label: 'المدة المتوقعة',
            value: duration == null ? '--' : '$duration min',
          ),
          const SizedBox(height: AppDimensions.paddingS),
          _InfoRow(
            label: 'رسوم التوصيل',
            value: fee == null ? '--' : '${fee.toStringAsFixed(0)} SAR',
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      elevation: 6,
      shadowColor: colors.shadow,
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      color: colors.bottomSheetBackground,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: child,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          style: TextStyle(color: colors.textSecondary, fontSize: 13),
        ),
        AppText(
          value,
          style: TextStyle(
            color: highlight ? AppColors.primary : colors.textPrimary,
            fontSize: 13,
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
