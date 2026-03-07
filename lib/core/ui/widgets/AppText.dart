import 'package:flutter/material.dart';
import 'AppTextStyles.dart';

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
    final baseStyle = secondary
        ? AppTextStyles.bodySecondary
        : AppTextStyles.body;

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
