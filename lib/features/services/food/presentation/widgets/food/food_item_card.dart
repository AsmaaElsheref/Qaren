import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors_ext.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../domain/entities/food_item.dart';
import '../../../domain/entities/food_warehouse.dart';
import '../../providers/food_cart_provider.dart';
import '../foodCart/food_quantity_stepper.dart';
import 'branch_selection_sheet.dart';
import 'food_add_button.dart';
import 'selected_branch_label.dart';

class FoodItemCard extends ConsumerWidget {
  const FoodItemCard({super.key, required this.item});

  final FoodItem item;

  /// First add: resolves which warehouse to use, prompting the user when
  /// more than one active branch is available. Subsequent increments reuse
  /// the previously selected warehouse stored on the cart item.
  Future<void> _onAddTap(BuildContext context, WidgetRef ref) async {
    final cartState = ref.read(foodCartProvider);
    final existing  = cartState.items[item.id];

    // Already in cart → just increment, keep selected warehouse.
    if (existing != null) {
      _commit(ref, existing.warehouse);
      return;
    }

    final active = item.activeWarehouses;

    // No branches → unavailable.
    if (active.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: AppText('هذا المنتج غير متوفر حالياً')),
      );
      return;
    }

    // Single branch → silent commit.
    if (active.length == 1) {
      _commit(ref, active.first);
      return;
    }

    // Multiple branches → ask the user.
    final picked = await BranchSelectionSheet.show(
      context,
      warehouses: active,
    );
    if (picked == null) return;
    _commit(ref, picked);
  }

  void _commit(WidgetRef ref, FoodWarehouse? warehouse) {
    ref.read(foodCartProvider.notifier).increment(
          item.id,
          name: item.name,
          imageUrl: item.imageUrl,
          price: item.price,
          comparePrice: item.comparePrice,
          warehouse: warehouse,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
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
                      color: colors.disabledBackground,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: Icon(
                      Icons.restaurant_rounded,
                      color: colors.textMuted,
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
                    color: colors.card,
                    borderRadius:
                    BorderRadius.circular(AppDimensions.radiusS),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow,
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
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
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
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                AppText(
                  item.description,
                  style: TextStyle(
                    fontSize: AppDimensions.fontXS,
                    color: colors.textSecondary,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      'ر.س',
                      style: TextStyle(
                        fontSize: AppDimensions.fontXS,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    AppText(
                      '${item.price.toInt()}',
                      style: TextStyle(
                        fontSize: AppDimensions.fontM,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                SelectedBranchLabel(itemId: item.id),
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
                    style: TextStyle(
                      fontSize: AppDimensions.fontXS,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (quantity == 0)
                FoodAddButton(onTap: () => _onAddTap(context, ref))
              else
                FoodQuantityStepper(
                  quantity: quantity,
                  onIncrement: () => _onAddTap(context, ref),
                  onDecrement: () =>
                      ref.read(foodCartProvider.notifier).decrement(item.id),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

