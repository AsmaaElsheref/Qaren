import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/features/services/taxi/presentation/providers/currentLocationProvider/current_location_provider.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../pages/map_picker_page.dart';
import '../providers/taxi_providers.dart';

class LocationPickerSheet extends ConsumerWidget {
  final TaxiActiveField field;

  const LocationPickerSheet({super.key, required this.field});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = field == TaxiActiveField.pickup ? 'نقطة الانطلاق' : 'الوجهة المطلوبة';
    final isLocationLoading = ref.watch(taxiIsLocationLoadingProvider);

    final state = ref.watch(taxiProvider);
    final otherLabel = field == TaxiActiveField.pickup ? state.destination : state.pickup;
    final otherLatLng = field == TaxiActiveField.pickup ? state.destinationLatLng : state.pickupLatLng;

    final currentLocationRead = ref.read(currentLocationProvider.notifier);
    final currentLocationWatch = ref.watch(currentLocationProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXL),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Handle ───────────────────────────────────────────────────
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(
                  top: AppDimensions.paddingM,
                  bottom: AppDimensions.paddingS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
                child: Row(
                  children: [
                    AppText(
                      title,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontL,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.border),

              // ── Use current location ──────────────────────────────────────
              _PickerOption(
                icon: Icons.my_location_rounded,
                iconColor: AppColors.primary,
                iconBgColor: AppColors.primaryLight,
                label: 'استخدم موقعي الحالي',
                labelColor: AppColors.primary,
                isLoading: isLocationLoading,
                onTap: isLocationLoading
                    ? null
                    : () async {
                        final error = await ref
                            .read(taxiProvider.notifier)
                            .useCurrentLocation(field,currentLocationWatch.value!.currentLocation!,currentLocationRead.myLocationName);
                        if (!context.mounted) return;
                        if (error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
              ),
              const Divider(height: 1, indent: 64, color: AppColors.border),

              // ── Pick on map ───────────────────────────────────────────────
              _PickerOption(
                icon: Icons.map_outlined,
                iconColor: AppColors.textSecondary,
                iconBgColor: AppColors.surfaceVariant,
                label: 'تحديد على الخريطة',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MapPickerPage(field: field),
                    ),
                  );
                },
              ),

              // ── Recent / other suggestion ─────────────────────────────────
              if (otherLabel.isNotEmpty && otherLatLng != null) ...[
                const Divider(height: 1, color: AppColors.border),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM,
                    vertical: AppDimensions.paddingS,
                  ),
                  child: Row(
                    children: [
                      AppText(
                        'مواقع سابقة',
                        secondary: true,
                        style: const TextStyle(fontSize: AppDimensions.fontXS),
                      ),
                    ],
                  ),
                ),
                _PickerOption(
                  icon: Icons.location_on_rounded,
                  iconColor: const Color(0xFFE85D5D),
                  iconBgColor: const Color(0xFFFFF0F0),
                  label: otherLabel,
                  onTap: () {
                    ref.read(taxiProvider.notifier).confirmLocation(
                          field: field,
                          latLng: otherLatLng,
                          label: otherLabel,
                        );
                    Navigator.of(context).pop();
                  },
                ),
              ],

              const SizedBox(height: AppDimensions.paddingM),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Option row ────────────────────────────────────────────────────────────────
class _PickerOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String label;
  final Color? labelColor;
  final VoidCallback? onTap;
  final bool isLoading;

  const _PickerOption({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingM,
        ),
        child: Row(
          children: [
            Expanded(
              child: AppText(
                label,
                style: TextStyle(
                  fontSize: AppDimensions.fontM,
                  fontWeight: FontWeight.w500,
                  color: labelColor,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: iconColor,
                      ),
                    )
                  : Icon(icon, color: iconColor, size: AppDimensions.iconS),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function — call this from any widget to show the sheet.
Future<void> showLocationPickerSheet(
  BuildContext context,
  TaxiActiveField field,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => LocationPickerSheet(field: field),
  );
}
