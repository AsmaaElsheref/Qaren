import 'package:flutter/material.dart';

/// Static text style presets — colours are intentionally omitted so each
/// style inherits from the ambient [DefaultTextStyle] / theme text colour.
/// Colour overrides happen in [AppText] via [AppColorTokens].
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle headline = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.35,
    fontFamily: 'DroidKufi',
  );

  static const TextStyle title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.45,
    fontFamily: 'DroidKufi',
  );

  static const TextStyle body = TextStyle(
    fontSize: 13,
    height: 1.55,
    fontFamily: 'DroidKufi',
  );

  static const TextStyle bodySecondary = TextStyle(
    fontSize: 12,
    height: 1.55,
    fontFamily: 'DroidKufi',
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    height: 1.45,
    fontFamily: 'DroidKufi',
  );
}


