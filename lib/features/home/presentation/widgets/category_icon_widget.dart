import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors_ext.dart';

/// Renders the coloured icon box for a service category card.
/// When [isEnabled] is false the icon uses the theme disabled tokens instead
/// of the semantic accent colour, so it reads well in both light and dark mode.
class CategoryIconWidget extends StatelessWidget {
  const CategoryIconWidget({
    super.key,
    required this.icon,
    required this.color,
    this.isEnabled = true,
  });

  final IconData icon;
  final Color color;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bgColor =
        isEnabled ? color.withValues(alpha: 0.14) : colors.disabledBackground;
    final iconColor = isEnabled ? color : colors.disabledText;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }
}
