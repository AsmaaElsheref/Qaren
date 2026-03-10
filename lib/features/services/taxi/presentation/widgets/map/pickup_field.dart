import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../providers/taxi_providers.dart';
import '../location_field.dart';
import '../location_picker_sheet.dart';

class PickupField extends ConsumerWidget {
  const PickupField({super.key});

  @override
  Widget build(BuildContext context, dynamic ref) {
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
