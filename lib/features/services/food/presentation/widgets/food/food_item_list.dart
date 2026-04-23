import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../providers/food_providers.dart';
import 'food_item_card.dart';
import 'food_item_shimmer.dart';

/// Renders the list of food items based on the current API response.
///
/// Handles loading, error, empty, and data states.
/// Rebuild scope: only this widget rebuilds when [foodItemsProvider] changes.
class FoodItemList extends ConsumerWidget {
  const FoodItemList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(foodItemsProvider);

    return asyncItems.when(
      loading: () => const FoodItemShimmer(),
      error: (_, __) => Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Center(
          child: AppText(
            'حدث خطأ في تحميل المنتجات',
            style: const TextStyle(
              fontSize: AppDimensions.fontS,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.paddingXL,
              horizontal: AppDimensions.paddingM,
            ),
            child: Center(
              child: AppText(
                'لا توجد نتائج',
                style: const TextStyle(
                  fontSize: AppDimensions.fontS,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            indent: AppDimensions.paddingM,
            endIndent: AppDimensions.paddingM,
            color: AppColors.border,
          ),
          itemBuilder: (context, index) => FoodItemCard(item: items[index]),
        );
      },
    );
  }
}
