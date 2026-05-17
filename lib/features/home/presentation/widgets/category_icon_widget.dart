import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Renders the coloured icon box for a service category card.
/// The [color] is the semantic accent colour for the category type and remains
/// the same in both light and dark mode (brand colour).
/// The icon background uses a low-opacity tint of [color] that reads well on
/// both light and dark surfaces.
class CategoryIconWidget extends StatelessWidget {
  const CategoryIconWidget({
    super.key,
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

