import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../../../../../core/utils/location_service.dart';
import '../pages/food_map_picker_page.dart';
import '../providers/food_providers.dart';

/// Bottom sheet shown before comparing prices.
/// Two options:
///  1. Use current GPS location — resolves instantly and closes.
///  2. Pick on map — opens [FoodMapPickerPage] and waits for LatLng.
///
/// Pops with the chosen [LatLng] so the caller can fire the API.
class FoodLocationPickerSheet extends ConsumerStatefulWidget {
  const FoodLocationPickerSheet({super.key});

  @override
  ConsumerState<FoodLocationPickerSheet> createState() =>
      _FoodLocationPickerSheetState();
}

class _FoodLocationPickerSheetState
    extends ConsumerState<FoodLocationPickerSheet> {
  bool _isGpsLoading = false;
  String? _error;

  // ── GPS ───────────────────────────────────────────────────────────────────

  Future<void> _useCurrentLocation() async {
    setState(() {
      _isGpsLoading = true;
      _error = null;
    });

    final result = await LocationService.getCurrentLocation();

    if (!mounted) return;

    if (!result.isSuccess) {
      setState(() {
        _isGpsLoading = false;
        _error = result.error;
      });
      return;
    }

    ref.read(foodSelectedLocationProvider.notifier).state = result.position;
    if (mounted) Navigator.of(context).pop(result.position);
  }

  // ── Map picker ────────────────────────────────────────────────────────────

  void _openMapPicker() {
    // Close the sheet with null — ComparePricesButton will push FoodMapPickerPage.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
              // ── Handle ──────────────────────────────────────────────────
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(
                  top: AppDimensions.paddingM,
                  bottom: AppDimensions.paddingS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusFull),
                ),
              ),

              // ── Title ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
                child: Row(
                  children: const [
                    AppText(
                      'اختر موقعك',
                      style: TextStyle(
                        fontSize: AppDimensions.fontL,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: AppColors.border),

              // ── Use current GPS location ─────────────────────────────────
              _LocationOption(
                icon: Icons.my_location_rounded,
                iconColor: AppColors.primary,
                iconBgColor: AppColors.primaryLight,
                label: 'استخدم موقعي الحالي',
                labelColor: AppColors.primary,
                isLoading: _isGpsLoading,
                onTap: _isGpsLoading ? null : _useCurrentLocation,
              ),

              if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM,
                  ),
                  child: AppText(
                    _error!,
                    style: const TextStyle(
                      fontSize: AppDimensions.fontXS,
                      color: Color(0xFFE85D5D),
                    ),
                  ),
                ),

              const Divider(
                height: 1,
                indent: AppDimensions.paddingXL,
                color: AppColors.border,
              ),

              // ── Pick on map ──────────────────────────────────────────────
              _LocationOption(
                icon: Icons.map_outlined,
                iconColor: AppColors.textSecondary,
                iconBgColor: AppColors.surfaceVariant,
                label: 'تحديد على الخريطة',
                onTap: _isGpsLoading ? null : _openMapPicker,
              ),

              const SizedBox(height: AppDimensions.paddingL),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Option row ────────────────────────────────────────────────────────────────

class _LocationOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String label;
  final Color? labelColor;
  final VoidCallback? onTap;
  final bool isLoading;

  const _LocationOption({
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
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            else
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}

