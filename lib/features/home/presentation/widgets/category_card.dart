import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors_ext.dart';
import '../../domain/entities/category_entity.dart';
import 'category_icon_resolver.dart';
import 'category_icon_widget.dart';
import 'category_labels.dart';

/// Tappable service-category card. All surface/border/shadow colours are
/// resolved via [AppColorTokens] so the card adapts to light and dark mode.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  final CategoryEntity category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: colors.border.withValues(alpha: 0.6)),
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CategoryIconWidget(
              icon: CategoryIconResolver.resolve(category.icon),
              color: CategoryIconResolver.colorFor(category.type),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CategoryLabels(
                name: category.name,
                description: category.description,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




