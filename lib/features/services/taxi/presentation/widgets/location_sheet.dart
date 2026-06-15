import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_colors_ext.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../providers/taxi_providers.dart';
import 'map/destination_field.dart';
import 'map/pickup_field.dart';
import 'price_compare_button.dart';

class LocationSheet extends ConsumerWidget {
  const LocationSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final sameLocation = ref.watch(taxiSameLocationProvider);
    return Container(
      decoration: BoxDecoration(
        color: colors.bottomSheetBackground,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 24,
            offset: const Offset(0, -6),
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
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
          ),
          PickupField(),
          const SizedBox(height: AppDimensions.paddingM),
          DestinationField(),
          if (sameLocation) ...[
            const SizedBox(height: AppDimensions.paddingM),
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 20),
                const SizedBox(width: AppDimensions.paddingS),
                Expanded(
                  child: AppText(
                    'نقطة الانطلاق والوجهة متطابقتان، يرجى اختيار وجهة مختلفة',
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppDimensions.paddingXL),
          // ── Date pickers ──────────────────────────────────────────────
          // const _DatePickersRow(),
          // const SizedBox(height: AppDimensions.paddingL),
          const PriceCompareButton(),
          const SizedBox(height: AppDimensions.paddingS),
        ],
      ),
    );
  }
}


