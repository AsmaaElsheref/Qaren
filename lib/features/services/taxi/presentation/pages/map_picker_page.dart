import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qaren/features/services/taxi/presentation/widgets/map/zoomControls/zoom_controls_map.dart';
import '../providers/taxi_providers.dart';
import '../widgets/map/confirmLocation/confirm_location_button.dart';
import '../widgets/map/pin_map.dart';
import '../widgets/map/searchMap/search_map.dart';

class MapPickerPage extends ConsumerWidget {
  final TaxiActiveField field;
  final LatLng? initialPosition;

  const MapPickerPage({
    super.key,
    required this.field,
    this.initialPosition,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(mapPickerProvider(field).notifier);
    final state = ref.watch(mapPickerProvider(field));
    final mapController = ref.watch(taxiMapControllerProvider);
    final title = field == TaxiActiveField.pickup
        ? 'تحديد نقطة الانطلاق'
        : 'تحديد الوجهة';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: PopScope(
        onPopInvokedWithResult: (_, __) =>
            ref.read(taxiMapPickerActiveProvider.notifier).state = false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              const PinMap(),
              SearchMap(
                searchController: notifier.searchController,
                searchAddress: (_) => notifier.searchAddress(),
              ),
              ZoomControlsMap(mapController: mapController),
              ConfirmLocationButton(
                title: title,
                addressLabel: state.addressLabel,
                isResolving: state.isResolving,
                isConfirming: state.isConfirming,
                confirm: () {
                  notifier.confirm();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
