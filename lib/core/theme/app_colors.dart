import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1DB899);
  static const Color primaryLight = Color(0xFFE8FAF6);
  static const Color primaryGlow = Color(0x331DB899);

  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F4F6);

  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFFADB5BD);

  static const Color border = Color(0xFFE5E7EB);
  static const Color borderFocused = Color(0xFF1DB899);

  static const Color error = Color(0xFFEF4444);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1DB899), Color(0xFF15A880)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient glowGradient = LinearGradient(
    colors: [Color(0x001DB899), Color(0x551DB899), Color(0x001DB899)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

