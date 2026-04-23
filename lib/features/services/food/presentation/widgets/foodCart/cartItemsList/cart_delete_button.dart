import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/theme/app_colors.dart';
import '../../../providers/food_providers.dart';

/// Delete icon button that removes an item from the cart entirely.
/// Uses ConsumerWidget so it can call the cart notifier.
class CartDeleteButton extends ConsumerWidget {
  const CartDeleteButton({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(foodCartProvider.notifier).remove(itemId),
      child: const Icon(
        Icons.delete_outline_rounded,
        size: 22,
        color: AppColors.textHint,
      ),
    );
  }
}

