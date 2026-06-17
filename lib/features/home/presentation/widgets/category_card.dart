import 'package:flutter/material.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_colors_ext.dart';
import '../../domain/entities/category_entity.dart';
import 'category_availability_badge.dart';
import 'category_icon_resolver.dart';
import 'category_icon_widget.dart';
import 'category_labels.dart';

/// Tappable (or disabled) service-category card.
///
/// Pass [isEnabled] = false to render the card in a muted, non-interactive
/// state with a "قريبًا" badge.  All surface/border/shadow colours are
/// resolved via [AppColorTokens] so the card adapts to light and dark mode.
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    this.isEnabled = true,
  });

  final CategoryEntity category;
  final VoidCallback? onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cardColor = colors.card;
    final borderColor = colors.border.withValues(alpha: 0.6);
    final shadowColor = colors.shadow;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: isEnabled ? CategoryIconResolver.colorFor(category.type).withValues(alpha: 0.05) : colors.disabledBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
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
              isEnabled: isEnabled,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CategoryLabels(
                name: category.name,
                description: category.description,
                isEnabled: isEnabled,
              ),
            ),
            if (!isEnabled) ...[
              const SizedBox(width: 4),
              const CategoryAvailabilityBadge(),
            ],
          ],
        ),
      ),
    );
  }
}
