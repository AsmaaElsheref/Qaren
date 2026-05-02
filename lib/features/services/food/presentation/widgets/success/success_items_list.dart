import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../food_strings.dart';
import '../../providers/food_providers.dart';
import 'success_item_card.dart';

/// Renders the ordered items returned in `data.children`.
///
/// Watches only [foodBookingResultProvider] (selecting children list) so
/// the section is fully isolated.
class SuccessItemsList extends ConsumerWidget {
  const SuccessItemsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(
      foodBookingResultProvider.select((r) => r?.children ?? const []),
    );
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
            child: AppText(
              FoodStrings.orderItemsSection,
              style: TextStyle(
                fontSize: AppDimensions.fontM,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          for (int i = 0; i < items.length; i++) ...[
            SuccessItemCard(item: items[i]),
            if (i != items.length - 1)
              const Divider(height: 1, color: AppColors.border),
          ],
        ],
      ),
    );
  }
}

