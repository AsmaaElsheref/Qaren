import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../pages/map_picker_page.dart';
import '../providers/taxi_providers.dart';

/// Modal bottom sheet shown when user taps a [LocationField].
///
/// Options:
///  1. استخدم موقعي الحالي  → (plug in geolocator when ready)
///  2. تحديد على الخريطة   → push [MapPickerPage]
///  3. Recent suggestions   → filled from [TaxiState]
///
/// Call via [showLocationPickerSheet].
class LocationPickerSheet extends ConsumerWidget {
  final TaxiActiveField field;

  const LocationPickerSheet({super.key, required this.field});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = field == TaxiActiveField.pickup
        ? 'نقطة الانطلاق'
        : 'الوجهة المطلوبة';

    // Grab the other field's existing label as a suggestion
    final state = ref.watch(taxiProvider);
    final otherLabel = field == TaxiActiveField.pickup
        ? state.destination
        : state.pickup;
    final otherLatLng = field == TaxiActiveField.pickup
        ? state.destinationLatLng
        : state.pickupLatLng;

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
              // ── Drag handle ───────────────────────────────────────────────
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

              // ── Title ─────────────────────────────────────────────────────
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

              // ── استخدم موقعي الحالي ───────────────────────────────────────
              _PickerOption(
                icon: Icons.my_location_rounded,
                iconColor: AppColors.primary,
                iconBgColor: AppColors.primaryLight,
                label: 'استخدم موقعي الحالي',
                labelColor: AppColors.primary,
                onTap: () {
                  // TODO: integrate geolocator
                  // For now, use Cairo default as placeholder
                  ref.read(taxiProvider.notifier).confirmLocation(
                        field: field,
                        latLng: const LatLng(30.0444, 31.2357),
                        label: 'موقعي الحالي',
                      );
                  Navigator.of(context).pop();
                },
              ),

              const Divider(height: 1, indent: 64, color: AppColors.border),

              // ── تحديد على الخريطة ─────────────────────────────────────────
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

// ── Helper ────────────────────────────────────────────────────────────────────
class _PickerOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String label;
  final Color? labelColor;
  final VoidCallback onTap;

  const _PickerOption({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.label,
    required this.onTap,
    this.labelColor,
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
              child: Icon(icon, color: iconColor, size: AppDimensions.iconS),
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

