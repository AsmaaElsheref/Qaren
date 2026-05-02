import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../providers/food_cart_provider.dart';

/// Tiny label showing the currently selected branch for a cart item.
///
/// Watches only the per-item warehouse selector so it rebuilds in
/// isolation — no other widget rebuilds when a branch is picked.
class SelectedBranchLabel extends ConsumerWidget {
  const SelectedBranchLabel({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warehouse = ref.watch(foodItemSelectedWarehouseProvider(itemId));
    if (warehouse == null) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.storefront_rounded,
          size: 12,
          color: AppColors.primary,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: AppText(
            warehouse.name,
            secondary: true,
            maxLines: 1,
            style: const TextStyle(
              fontSize: AppDimensions.fontXS,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

