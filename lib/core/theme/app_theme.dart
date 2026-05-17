import 'package:flutter/material.dart';
import 'app_color_tokens.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const _fontFamily = 'Cairo';

  static final _inputThemeLight = _buildInputTheme(
    fill: AppColorTokens.light.inputBackground,
    border: AppColorTokens.light.border,
  );

  static final _inputThemeDark = _buildInputTheme(
    fill: AppColorTokens.dark.inputBackground,
    border: AppColorTokens.dark.border,
  );

  static InputDecorationTheme _buildInputTheme({
    required Color fill,
    required Color border,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }

  static final _buttonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      minimumSize: const Size(double.infinity, 56),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
    ),
  );

  // ── Light ────────────────────────────────────────────────────────────────

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        surface: AppColorTokens.light.surface,
      ),
      scaffoldBackgroundColor: AppColorTokens.light.background,
      cardColor: AppColorTokens.light.card,
      dividerColor: AppColorTokens.light.divider,
      inputDecorationTheme: _inputThemeLight,
      elevatedButtonTheme: _buttonTheme,
      extensions: const [AppColorTokens.light],
    );
  }

  // ── Dark ─────────────────────────────────────────────────────────────────

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        surface: AppColorTokens.dark.surface,
      ),
      scaffoldBackgroundColor: AppColorTokens.dark.background,
      cardColor: AppColorTokens.dark.card,
      dividerColor: AppColorTokens.dark.divider,
      inputDecorationTheme: _inputThemeDark,
      elevatedButtonTheme: _buttonTheme,
      extensions: const [AppColorTokens.dark],
      iconTheme: IconThemeData(color: AppColors.surface)
    );
  }
}

