import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/profile/presentation/providers/profileSettings/profile_settings_provider.dart';

/// Derives [ThemeMode] from the existing profile settings dark mode flag.
/// Only rebuilds [QarenApp] when isDarkMode changes.
final appThemeModeProvider = Provider<ThemeMode>((ref) {
  final isDark = ref.watch(profileIsDarkModeProvider);
  return isDark ? ThemeMode.dark : ThemeMode.light;
});

