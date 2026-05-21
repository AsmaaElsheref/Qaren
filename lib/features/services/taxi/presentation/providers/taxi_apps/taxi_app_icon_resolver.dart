import 'package:flutter/material.dart';

/// Maps a provider slug returned by the API to a display icon and brand colors.
/// Falls back to a neutral car icon / grey palette for unknown slugs.
class TaxiAppIconResolver {
  TaxiAppIconResolver._();

  static IconData iconFor(String slug) =>
      _icons[slug] ?? Icons.directions_car_outlined;

  static Color bgColorFor(String slug) =>
      _bgColors[slug] ?? const Color(0xFF607D8B);

  static Color iconColorFor(String slug) => const Color(0xFFFFFFFF);

  // ── Maps ────────────────────────────────────────────────────────────────────

  static const Map<String, IconData> _icons = {
    'uber':   Icons.directions_car_rounded,
    'careem': Icons.directions_car_filled_rounded,
    'jeeny':  Icons.electric_car_rounded,
    'bolt':   Icons.bolt_rounded,
    'yelo':   Icons.local_taxi_rounded,
    'lumi':   Icons.drive_eta_rounded,
  };

  static const Map<String, Color> _bgColors = {
    'uber':   Color(0xFF1A1A1A),
    'careem': Color(0xFF1DB954),
    'jeeny':  Color(0xFF0066CC),
    'bolt':   Color(0xFF34D058),
    'yelo':   Color(0xFFFFCC00),
    'lumi':   Color(0xFF9B59B6),
  };
}

