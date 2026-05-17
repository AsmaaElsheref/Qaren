import 'package:flutter/material.dart';
import '../../theme/app_colors_ext.dart';
import 'AppTextStyles.dart';

/// Theme-aware text widget.
/// Uses [AppColorTokens.textPrimary] by default, or [AppColorTokens.textSecondary]
/// when [secondary] is true.
/// Any explicit [style] color will override the token color.
class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool secondary;
  final TextDirection? textDirection;

  const AppText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
    this.secondary = false,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final defaultColor =
        secondary ? tokens.textSecondary : tokens.textPrimary;

    final baseStyle = (secondary ? AppTextStyles.bodySecondary : AppTextStyles.body)
        .copyWith(color: defaultColor);

    return Text(
      text,
      style: baseStyle.merge(style),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      textDirection: textDirection,
    );
  }
}


