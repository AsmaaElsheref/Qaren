import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/features/home/domain/entities/category_entity.dart';

// ── Icon & colour resolver ─────────────────────────────────────────────────────

class _IconResolver {
  _IconResolver._();

  static IconData resolveIcon(String apiIcon) =>
      _iconMap[apiIcon] ?? Icons.category_outlined;

  static const Map<String, IconData> _iconMap = {
    'car':          Icons.directions_car_outlined,
    'car-front':    Icons.car_rental_outlined,
    'utensils':     Icons.restaurant_menu_rounded,
    'plane':        Icons.flight_outlined,
    'building':     Icons.apartment_outlined,
    'shield-check': Icons.verified_user_outlined,
    'shopping-bag': Icons.shopping_bag_outlined,
    'hammer':       Icons.handyman_outlined,
    'truck':        Icons.local_shipping_outlined,
    'package':      Icons.inventory_2_outlined,
    'scissors':     Icons.cut,
    'ticket':       Icons.confirmation_num_outlined,
  };

  static Color resolveColor(String type) =>
      _colorMap[type] ?? AppColors.primary;

  static const Map<String, Color> _colorMap = {
    'taxi':          Color(0xFFFF9500),
    'food_delivery': Color(0xFFE85D5D),
    'flights':       Color(0xFF5B9BD5),
    'hotels':        Color(0xFF6B7FD7),
    'insurance':     Color(0xFF1DB899),
    'car_rental':    Color(0xFF9B7FD7),
    'shopping':      Color(0xFFE85D9A),
    'home_services': Color(0xFFD4A017),
    'furniture':     Color(0xFF6B7280),
    'parcel':        Color(0xFF1DB899),
    'salon':         Color(0xFFE85D5D),
    'events':        Color(0xFF5B9BD5),
  };
}

// ── CategoryCard ───────────────────────────────────────────────────────────────

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _CategoryIconWidget(
              icon: _IconResolver.resolveIcon(category.icon),
              color: _IconResolver.resolveColor(category.type),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _CategoryLabels(
                name:        category.name,
                description: category.description,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private sub-widgets ────────────────────────────────────────────────────────

class _CategoryIconWidget extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _CategoryIconWidget({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _CategoryLabels extends StatelessWidget {
  final String name;
  final String description;

  const _CategoryLabels({required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: AppDimensions.fontS,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            height: 1.3,
          ),
        ),
        Text(
          description,
          textAlign: TextAlign.right,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: AppDimensions.fontXS,
            color: AppColors.textSecondary,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}



