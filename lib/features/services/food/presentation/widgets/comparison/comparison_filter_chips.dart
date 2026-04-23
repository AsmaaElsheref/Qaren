import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../domain/entities/food_sort_type.dart';
import '../../providers/food_comparison_provider.dart';
import '../../providers/food_providers.dart';

/// Segmented sort filter chips: المقترح / الأرخص / الأسرع.
/// Only rebuilds when [foodSortTypeProvider] changes.
class ComparisonFilterChips extends ConsumerWidget {
  const ComparisonFilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(foodSortTypeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        child: Row(
          children: FoodSortType.values.map((type) {
            final isActive = active == type;
            return Expanded(
              child: GestureDetector(
                onTap: () =>
                    ref.read(foodSortTypeProvider.notifier).state = type,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color:
                        isActive ? AppColors.textPrimary : Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        type.icon,
                        size: 14,
                        color: isActive
                            ? AppColors.white
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      AppText(
                        type.label,
                        style: TextStyle(
                          fontSize: AppDimensions.fontS,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? AppColors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

