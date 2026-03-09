import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../core/theme/app_colors.dart';
import '../widgets/taxi_map_view.dart';
import '../widgets/taxi_top_bar.dart';
import '../widgets/location_sheet.dart';

class TaxiPage extends StatelessWidget {
  const TaxiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const RepaintBoundary(
                    child: TaxiMapView(),
                  ),
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: TaxiTopBar(),
                  ),
                ],
              ),
            ),

            // ── Bottom sheet panel ─────────────────────────────────────────
            const LocationSheet(),
          ],
        ),
      ),
    );
  }
}

