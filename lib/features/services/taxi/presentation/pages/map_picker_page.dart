import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qaren/features/services/taxi/presentation/widgets/map/zoomControls/zoom_controls_map.dart';
import '../providers/taxi_providers.dart';
import '../widgets/map/confirm_location_button.dart';
import '../widgets/map/pin_map.dart';
import '../widgets/map/search_map.dart';

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
  GoogleMapController? _mapController;
  final _searchController = TextEditingController();

  LatLng _centerLatLng = const LatLng(30.0444, 31.2357);
  String _addressLabel = 'جاري تحديد الموقع...';
  bool _isResolving = false;
  bool _isConfirming = false;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.initialPosition != null) {
      _centerLatLng = widget.initialPosition!;
    }
    // Resolve initial address after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolveAddress(_centerLatLng));
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ── Reverse geocode ───────────────────────────────────────────────────────
  Future<void> _resolveAddress(LatLng pos) async {
    setState(() => _isResolving = true);
    try {
      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      if (placemarks.isNotEmpty && mounted) {
        final p = placemarks.first;
        final parts = [
          p.street,
          p.subLocality,
          p.locality,
        ].where((s) => s != null && s.isNotEmpty).toList();
        setState(() {
          _addressLabel = parts.isNotEmpty ? parts.join('، ') : 'موقع غير معروف';
          _isResolving = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _addressLabel = 'تعذّر تحديد الموقع';
          _isResolving = false;
        });
      }
    }
  }

  // ── Forward geocode (search) ──────────────────────────────────────────────
  Future<void> _searchAddress(String query) async {
    if (query.trim().isEmpty) return;
    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty && _mapController != null) {
        final loc = locations.first;
        final target = LatLng(loc.latitude, loc.longitude);
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(target, 16),
        );
        // onCameraIdle will trigger _resolveAddress automatically
      }
    } catch (_) {
      // silently ignore — user can adjust manually
    }
  }

  void _onCameraMove(CameraPosition position) {
    _centerLatLng = position.target;
  }

  void _onCameraIdle() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _resolveAddress(_centerLatLng);
    });
  }

  Future<void> _confirm() async {
    setState(() => _isConfirming = true);
    ref.read(taxiProvider.notifier).confirmLocation(
      field: widget.field,
      latLng: _centerLatLng,
      label: _addressLabel,
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.field == TaxiActiveField.pickup
        ? 'تحديد نقطة الانطلاق'
        : 'تحديد الوجهة';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _centerLatLng,
                zoom: 15,
              ),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              onMapCreated: (c) => _mapController = c,
              onCameraMove: _onCameraMove,
              onCameraIdle: _onCameraIdle,

            ),
            const PinMap(),
            SearchMap(searchController: _searchController,searchAddress: _searchAddress,),
            ZoomControlsMap(mapController: _mapController,),
            ConfirmLocationButton(
              title: title,
              addressLabel: _addressLabel,
              isConfirming: _isConfirming,
              isResolving: _isResolving,
              confirm: _confirm,
            )

          ],
        ),
      ),
    );
  }
}
