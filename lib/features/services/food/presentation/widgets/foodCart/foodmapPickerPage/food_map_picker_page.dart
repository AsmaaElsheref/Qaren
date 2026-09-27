import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qaren/core/config/config.dart';
import 'package:qaren/core/localization/easy_localization.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/map_unavailable_view.dart';

import '../../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../../core/constants/map_stayles.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/ui/widgets/AppButton.dart';
import '../../../../../../../core/ui/widgets/AppText.dart';
import '../../../../../../../core/utils/location_service.dart';
import '../../../../domain/entities/food_location_result.dart';

/// Standalone map picker for the food feature.
/// Drag the map → centre pin locks onto the chosen spot.
/// Tap confirm → pops with [FoodLocationResult] (LatLng + address name).
class FoodMapPickerPage extends StatefulWidget {
  const FoodMapPickerPage({super.key, this.initialPosition});

  final LatLng? initialPosition;

  @override
  State<FoodMapPickerPage> createState() => _FoodMapPickerPageState();
}

class _FoodMapPickerPageState extends State<FoodMapPickerPage> {
  // ── Cairo fallback ────────────────────────────────────────────────────────
  static const LatLng _cairo = LatLng(30.0444, 31.2357);

  GoogleMapController? _mapController;
  LatLng _pickedLatLng = _cairo;
  String _addressLabel = 'food.location.resolving';
  bool _isResolving = false;

  @override
  void initState() {
    super.initState();
    _pickedLatLng = widget.initialPosition ?? _cairo;
    _resolveAddress(_pickedLatLng);
  }

  // ── Reverse geocode ───────────────────────────────────────────────────────

  Future<void> _resolveAddress(LatLng latLng) async {
    setState(() => _isResolving = true);
    try {
      final marks = await geo.placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (!mounted) return;
      if (marks.isNotEmpty) {
        final p = marks.first;
        final parts = [
          p.street,
          p.subLocality,
          p.locality,
        ].where((s) => s != null && s.isNotEmpty).toList();
        setState(() {
          _addressLabel = parts.isNotEmpty
              ? parts.join(', ')
              : 'food.location.unknown';
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _addressLabel = 'food.location.resolveFailed');
      }
    } finally {
      if (mounted) setState(() => _isResolving = false);
    }
  }

  // ── GPS jump ──────────────────────────────────────────────────────────────

  Future<void> _goToMyLocation() async {
    final result = await LocationService.getCurrentLocation();
    if (!mounted) return;
    if (!result.isSuccess) return;
    final pos = result.position!;
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, 15));
    setState(() => _pickedLatLng = pos);
    _resolveAddress(pos);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  String _localizedAddressLabel() {
    if (_addressLabel.startsWith('food.location.')) return _addressLabel.tr();
    return _addressLabel;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (!AppConfig.hasGoogleMapsApiKey) {
      return Scaffold(
        body: Stack(
          children: [
            const MapUnavailableView(
              titleKey: 'food.location.mapDisabledTitle',
              messageKey: 'food.location.mapDisabledMessage',
            ),
            PositionedDirectional(
              top: MediaQuery.of(context).padding.top + AppDimensions.paddingS,
              start: AppDimensions.paddingM,
              child: _CircleIconButton(
                icon: Icons.arrow_back_ios_rounded,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // ── Map ──────────────────────────────────────────────────────────
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickedLatLng,
              zoom: 14,
            ),
            style: isDarkMode ? MapStyles.dark : null,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (c) => _mapController = c,
            onCameraMove: (pos) {
              _pickedLatLng = pos.target;
            },
            onCameraIdle: () => _resolveAddress(_pickedLatLng),
          ),

          // ── Centre pin ───────────────────────────────────────────────────
          const _FoodMapPin(),

          // ── Back button ──────────────────────────────────────────────────
          PositionedDirectional(
            top: MediaQuery.of(context).padding.top + AppDimensions.paddingS,
            start: AppDimensions.paddingM,
            child: _CircleIconButton(
              icon: Icons.arrow_back_ios_rounded,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),

          // ── GPS button ───────────────────────────────────────────────────
          PositionedDirectional(
            bottom: 180,
            end: AppDimensions.paddingM,
            child: _CircleIconButton(
              icon: Icons.my_location_rounded,
              onTap: _goToMyLocation,
            ),
          ),

          // ── Confirm button ───────────────────────────────────────────────
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.paddingM,
                  0,
                  AppDimensions.paddingM,
                  AppDimensions.paddingM,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _AddressCard(
                      address: _addressLabel,
                      isResolving: _isResolving,
                    ),
                    const SizedBox(height: AppDimensions.paddingM),
                    AppButton(
                      label: 'food.location.confirm'.tr(),
                      icon: Icons.check_circle_outline_rounded,
                      onTap: _isResolving
                          ? null
                          : () => Navigator.of(context).pop(
                              FoodLocationResult(
                                latLng: _pickedLatLng,
                                name: _localizedAddressLabel(),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Address card ──────────────────────────────────────────────────────────────

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address, required this.isResolving});

  final String address;
  final bool isResolving;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final displayedAddress = _localizedAddress(address);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingM,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: isResolving
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppText(
                        'food.location.selecting'.tr(),
                        secondary: true,
                        style: const TextStyle(fontSize: AppDimensions.fontS),
                      ),
                      const SizedBox(width: 8),
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  )
                : AppText(
                    displayedAddress,
                    style: TextStyle(
                      fontSize: AppDimensions.fontS,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
          const SizedBox(width: AppDimensions.paddingS),
          const Icon(
            Icons.location_on_rounded,
            color: AppColors.primary,
            size: 20,
          ),
        ],
      ),
    );
  }

  String _localizedAddress(String value) {
    if (value.startsWith('food.location.')) return value.tr();
    return value;
  }
}

// ── Circle icon button ────────────────────────────────────────────────────────

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: colors.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: colors.textPrimary),
      ),
    );
  }
}

// ── Centre pin ────────────────────────────────────────────────────────────────

class _FoodMapPin extends StatelessWidget {
  const _FoodMapPin();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: AppColors.white,
              size: 22,
            ),
          ),
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            width: 10,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.black.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
