import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../../domain/entities/restaurant.dart';

class FoodRestaurantHeader extends StatelessWidget {
  const FoodRestaurantHeader({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            child: Image.network(
              restaurant.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  color: AppColors.textHint,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                restaurant.name,
                style: const TextStyle(
                  fontSize: AppDimensions.fontM,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    '${restaurant.menuCount} ${restaurant.category}',
                    style: const TextStyle(
                      fontSize: AppDimensions.fontXS,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AppText(
                    '|',
                    style: const TextStyle(
                      fontSize: AppDimensions.fontXS,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        restaurant.deliveryTime,
                        style: const TextStyle(
                          fontSize: AppDimensions.fontXS,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: AppColors.textHint,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFE8FAF6),
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: Color(0xFFFFC107),
                ),
                const SizedBox(width: 4),
                AppText(
                  restaurant.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: AppDimensions.fontXS,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
