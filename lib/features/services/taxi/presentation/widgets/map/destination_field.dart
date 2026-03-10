import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/taxi_providers.dart';
import '../location_field.dart';
import '../location_picker_sheet.dart';

class DestinationField extends ConsumerWidget {
  const DestinationField({super.key});

  @override
  Widget build(BuildContext context, dynamic ref) {
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
