import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import 'package:qaren/features/services/taxi/presentation/widgets/map/zoomControls/zoom_button.dart';
import '../../../../../../../core/constants/app_dimensions.dart';

class ZoomControlsMap extends StatelessWidget {
  const ZoomControlsMap({super.key, this.mapController});

  final GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppDimensions.paddingM,
      bottom: context.screenHeight*0.23,
      child: Column(
        children: [
          ZoomButton(
            icon: Icons.add,
            onTap: () => mapController?.animateCamera(CameraUpdate.zoomIn()),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          ZoomButton(
            icon: Icons.remove,
            onTap: () => mapController?.animateCamera(CameraUpdate.zoomOut()),
          ),
        ],
      ),
    );
  }
}
