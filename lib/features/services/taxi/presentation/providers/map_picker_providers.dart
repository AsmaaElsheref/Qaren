import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'map_picker_notifier.dart';
import 'map_picker_state.dart';
import 'taxi_state.dart' show TaxiActiveField;

/// Family provider — one isolated instance per [TaxiActiveField].
/// Auto-disposed when the map-picker page is popped.
final mapPickerProvider = NotifierProvider.autoDispose
    .family<MapPickerNotifier, MapPickerState, TaxiActiveField>(
  MapPickerNotifier.new,
);

