import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../../domain/entities/food_item.dart';
import '../providers/food_providers.dart';
import 'food_add_button.dart';
import 'food_quantity_stepper.dart';

class FoodItemCard extends ConsumerWidget {
  const FoodItemCard({super.key, required this.item});

  final FoodItem item;

  void _increment(WidgetRef ref) {
    ref.read(foodCartProvider.notifier).increment(
      item.id,
      name: item.name,
      imageUrl: item.imageUrl,
      price: item.price,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(foodItemQuantityProvider(item.id));
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                child: Image.network(
                  item.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius:
                      BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: const Icon(
                      Icons.restaurant_rounded,
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              ),
              // Rating badge
              Positioned(
                bottom: 4,
                left: 4,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                    BorderRadius.circular(AppDimensions.radiusS),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 12,
                        color: Color(0xFFFFC107),
                      ),
                      const SizedBox(width: 2),
                      AppText(
                        item.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  item.name,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontM,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                AppText(
                  item.description,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontXS,
                    color: AppColors.textSecondary,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      'ر.س',
                      style: const TextStyle(
                        fontSize: AppDimensions.fontXS,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    AppText(
                      '${item.price.toInt()}',
                      style: const TextStyle(
                        fontSize: AppDimensions.fontM,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 4),
              // Calories
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_fire_department_outlined,
                    size: 14,
                    color: Color(0xFFFF9500),
                  ),
                  const SizedBox(width: 2),
                  AppText(
                    '${item.calories}',
                    style: const TextStyle(
                      fontSize: AppDimensions.fontXS,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (quantity == 0)
                FoodAddButton(onTap: () => _increment(ref),)
              else
                FoodQuantityStepper(
                  quantity: quantity,
                  onIncrement: () => _increment(ref),
                  onDecrement: () => ref.read(foodCartProvider.notifier).decrement(item.id),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

