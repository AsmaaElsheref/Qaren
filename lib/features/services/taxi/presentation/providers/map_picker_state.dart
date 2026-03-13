import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerState {
  final LatLng center;
  final String addressLabel;
  final bool isResolving;
  final bool isConfirming;

  const MapPickerState({
    required this.center,
    this.addressLabel = 'جاري تحديد الموقع...',
    this.isResolving = true,
    this.isConfirming = false,
  });

  MapPickerState copyWith({
    LatLng? center,
    String? addressLabel,
    bool? isResolving,
    bool? isConfirming,
  }) =>
      MapPickerState(
        center: center ?? this.center,
        addressLabel: addressLabel ?? this.addressLabel,
        isResolving: isResolving ?? this.isResolving,
        isConfirming: isConfirming ?? this.isConfirming,
      );
}

