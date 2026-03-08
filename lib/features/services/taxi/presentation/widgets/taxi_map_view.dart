import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';

/// The map placeholder that fills the top portion of the screen.
/// Kept as a plain [StatelessWidget] — completely isolated from Riverpod,
/// so it never participates in any rebuild cycle.
class TaxiMapView extends StatelessWidget {
  const TaxiMapView({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace this Container with google_maps_flutter / flutter_map
    // when the map package is added; the widget contract stays the same.
    return Container(
      color: const Color(0xFFE8E0D8),
      child: Stack(
        children: [
          // Grid lines simulating a city map
          CustomPaint(
            painter: _MapGridPainter(),
            child: const SizedBox.expand(),
          ),
          // Subtle brand tint overlay
          Container(
            color: AppColors.primary.withValues(alpha: 0.04),
          ),
          // "Map" label for placeholder
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
                vertical: AppDimensions.paddingS,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.85),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_outlined,
                      color: AppColors.primary, size: AppDimensions.iconS),
                  SizedBox(width: 6),
                  Text(
                    'خريطة المنطقة',
                    style: TextStyle(
                      fontSize: AppDimensions.fontXS,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lightweight custom painter for the street-grid map placeholder.
/// Uses [repaint] = false so Flutter never marks it dirty.
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFFF5EFE6)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;

    final minorPaint = Paint()
      ..color = const Color(0xFFEDE6DB)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    // Major horizontal roads
    for (double y = 0; y < size.height; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), roadPaint);
    }
    // Major vertical roads
    for (double x = 0; x < size.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), roadPaint);
    }
    // Minor horizontal roads
    for (double y = 30; y < size.height; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), minorPaint);
    }
    // Minor vertical roads
    for (double x = 30; x < size.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), minorPaint);
    }
  }

  // Never repaint — grid is static
  @override
  bool shouldRepaint(_MapGridPainter old) => false;
}

