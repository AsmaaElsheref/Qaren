import 'package:flutter/material.dart';
import 'app_color_tokens.dart';

/// Convenience extension so any widget can write:
///   `context.appColors.surface`
extension AppColorsContext on BuildContext {
  AppColorTokens get appColors =>
      Theme.of(this).extension<AppColorTokens>() ?? AppColorTokens.light;
}

