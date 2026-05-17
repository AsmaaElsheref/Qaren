import 'package:flutter/material.dart';

/// Theme-aware design tokens for Qaren.
/// Register in both [AppTheme.lightTheme] and [AppTheme.darkTheme] via
/// [ThemeData.extensions].
///
/// Access from any widget with:
///   `context.appColors.surface`
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  const AppColorTokens({
    required this.background,
    required this.surface,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.divider,
    required this.shadow,
    required this.inputBackground,
    required this.disabledBackground,
    required this.disabledText,
    required this.bottomNavBackground,
    required this.bottomSheetBackground,
    required this.iconBackground,
  });

  final Color background;
  final Color surface;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color divider;
  final Color shadow;
  final Color inputBackground;
  final Color disabledBackground;
  final Color disabledText;
  final Color bottomNavBackground;
  final Color bottomSheetBackground;
  final Color iconBackground;

  // ── Light token set ──────────────────────────────────────────────────────

  static const light = AppColorTokens(
    background:           Color(0xFFF8F9FA),
    surface:              Color(0xFFFFFFFF),
    card:                 Color(0xFFFFFFFF),
    textPrimary:          Color(0xFF1A1A2E),
    textSecondary:        Color(0xFF6B7280),
    textMuted:            Color(0xFFADB5BD),
    border:               Color(0xFFE5E7EB),
    divider:              Color(0xFFE5E7EB),
    shadow:               Color(0x0A000000),
    inputBackground:      Color(0xFFFFFFFF),
    disabledBackground:   Color(0xFFF3F4F6),
    disabledText:         Color(0xFFADB5BD),
    bottomNavBackground:  Color(0xFFFFFFFF),
    bottomSheetBackground:Color(0xFFFFFFFF),
    iconBackground:       Color(0xFFF3F4F6),
  );

  // ── Dark token set ───────────────────────────────────────────────────────

  static const dark = AppColorTokens(
    background:           Color(0xFF0F0F17),
    surface:              Color(0xFF1A1A28),
    card:                 Color(0xFF1E1E2E),
    textPrimary:          Color(0xFFF0F0F8),
    textSecondary:        Color(0xFF9CA3AF),
    textMuted:            Color(0xFF6B7280),
    border:               Color(0xFF2A2A3E),
    divider:              Color(0xFF2A2A3E),
    shadow:               Color(0x00000000),
    inputBackground:      Color(0xFF1E1E2E),
    disabledBackground:   Color(0xFF2A2A3E),
    disabledText:         Color(0xFF6B7280),
    bottomNavBackground:  Color(0xFF1A1A28),
    bottomSheetBackground:Color(0xFF1A1A28),
    iconBackground:       Color(0xFF2A2A3E),
  );

  // ── ThemeExtension boilerplate ───────────────────────────────────────────

  @override
  AppColorTokens copyWith({
    Color? background,
    Color? surface,
    Color? card,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
    Color? divider,
    Color? shadow,
    Color? inputBackground,
    Color? disabledBackground,
    Color? disabledText,
    Color? bottomNavBackground,
    Color? bottomSheetBackground,
    Color? iconBackground,
  }) {
    return AppColorTokens(
      background:            background            ?? this.background,
      surface:               surface               ?? this.surface,
      card:                  card                  ?? this.card,
      textPrimary:           textPrimary           ?? this.textPrimary,
      textSecondary:         textSecondary         ?? this.textSecondary,
      textMuted:             textMuted             ?? this.textMuted,
      border:                border                ?? this.border,
      divider:               divider               ?? this.divider,
      shadow:                shadow                ?? this.shadow,
      inputBackground:       inputBackground       ?? this.inputBackground,
      disabledBackground:    disabledBackground    ?? this.disabledBackground,
      disabledText:          disabledText          ?? this.disabledText,
      bottomNavBackground:   bottomNavBackground   ?? this.bottomNavBackground,
      bottomSheetBackground: bottomSheetBackground ?? this.bottomSheetBackground,
      iconBackground:        iconBackground        ?? this.iconBackground,
    );
  }

  @override
  AppColorTokens lerp(AppColorTokens? other, double t) {
    if (other == null) return this;
    return AppColorTokens(
      background:            Color.lerp(background,            other.background,            t)!,
      surface:               Color.lerp(surface,               other.surface,               t)!,
      card:                  Color.lerp(card,                  other.card,                  t)!,
      textPrimary:           Color.lerp(textPrimary,           other.textPrimary,           t)!,
      textSecondary:         Color.lerp(textSecondary,         other.textSecondary,         t)!,
      textMuted:             Color.lerp(textMuted,             other.textMuted,             t)!,
      border:                Color.lerp(border,                other.border,                t)!,
      divider:               Color.lerp(divider,               other.divider,               t)!,
      shadow:                Color.lerp(shadow,                other.shadow,                t)!,
      inputBackground:       Color.lerp(inputBackground,       other.inputBackground,       t)!,
      disabledBackground:    Color.lerp(disabledBackground,    other.disabledBackground,    t)!,
      disabledText:          Color.lerp(disabledText,          other.disabledText,          t)!,
      bottomNavBackground:   Color.lerp(bottomNavBackground,   other.bottomNavBackground,   t)!,
      bottomSheetBackground: Color.lerp(bottomSheetBackground, other.bottomSheetBackground, t)!,
      iconBackground:        Color.lerp(iconBackground,        other.iconBackground,        t)!,
    );
  }
}

