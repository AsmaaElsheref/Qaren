import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../providers/taxi_providers.dart';
import 'location_field.dart';
import 'location_picker_sheet.dart';
import 'price_compare_button.dart';

class LocationSheet extends ConsumerWidget {
  const LocationSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingM,
        AppDimensions.paddingM,
        AppDimensions.paddingM,
        AppDimensions.paddingM + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──────────────────────────────────────────────────
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
          ),

          _PickupField(),
          const SizedBox(height: AppDimensions.paddingM),
          _DestinationField(),
          const SizedBox(height: AppDimensions.paddingL),
          const PriceCompareButton(),
          const SizedBox(height: AppDimensions.paddingS),
        ],
      ),
    );
  }
}

// ── Scoped sub-widgets ────────────────────────────────────────────────────────

class _PickupField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(taxiProvider.select((s) => s.pickup));
    return LocationField(
      hint: 'نقطة الانطلاق',
      leadingIcon: Icons.location_on_rounded,
      iconColor: AppColors.primary,
      iconBgColor: AppColors.primaryLight,
      value: value,
      onTap: () => showLocationPickerSheet(context, TaxiActiveField.pickup),
    );
  }
}

class _DestinationField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(taxiProvider.select((s) => s.destination));
    return LocationField(
      hint: 'الوجهة المطلوبة',
      leadingIcon: Icons.near_me_rounded,
      iconColor: const Color(0xFFE85D5D),
      iconBgColor: const Color(0xFFFFF0F0),
      value: value,
      onTap: () => showLocationPickerSheet(context, TaxiActiveField.destination),
    );
  }
}
