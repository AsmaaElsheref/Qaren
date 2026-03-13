import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qaren/features/services/taxi/presentation/providers/currentLocationProvider/current_location_provider.dart';
import '../providers/taxi_providers.dart';
import '../widgets/map/confirmLocation/confirm_location_button.dart';
import '../widgets/map/pin_map.dart';
import '../widgets/map/searchMap/search_map.dart';
import '../widgets/map/zoomControls/zoom_controls_map.dart';
import '../widgets/taxi_map_view.dart';

/// A transparent overlay that lives on top of the shared [TaxiMapView].
/// It does NOT create its own GoogleMap instance — the map is already
/// rendered in [TaxiPage]; this page only adds the picker UI on top.
class MapPickerPage extends ConsumerStatefulWidget {
  final TaxiActiveField field;
  final LatLng? initialPosition;

  const MapPickerPage({
    super.key,
    required this.field,
    this.initialPosition,
  });

  @override
  ConsumerState<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends ConsumerState<MapPickerPage> {

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(mapPickerProvider(widget.field).notifier);
    final state = ref.watch(mapPickerProvider(widget.field));
    final mapController = ref.watch(taxiMapControllerProvider);
    final title = widget.field == TaxiActiveField.pickup
        ? 'تحديد نقطة الانطلاق'
        : 'تحديد الوجهة';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // Transparent so the shared GoogleMap behind it shows through.
        backgroundColor: Colors.transparent,
          body: Stack(
          children: [
            const RepaintBoundary(
              child: TaxiMapView(isPicker: true,),
            ),
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
              confirm: () async {
                await notifier.confirm();
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
