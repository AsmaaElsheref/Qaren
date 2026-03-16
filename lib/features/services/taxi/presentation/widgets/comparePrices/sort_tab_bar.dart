import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../data/models/comparePrices/compare_prices_model.dart';
import '../../providers/comparePricesProvider/compare_prices_provider.dart';

/// Segmented sort tab bar — المقترح / الأرخص / الأسرع.
/// Only rebuilds when the active sort type changes.
class SortTabBar extends ConsumerWidget {
  const SortTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(compareSortTypeProvider);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Row(
        children: CompareSortType.values.map((type) {
          return Expanded(
            child: _SortTab(
              type: type,
              isActive: active == type,
              onTap: () =>
                  ref.read(comparePricesProvider.notifier).setSort(type),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Private ───────────────────────────────────────────────────────────────────

class _SortTab extends StatelessWidget {
  const _SortTab({
    required this.type,
    required this.isActive,
    required this.onTap,
  });

  final CompareSortType type;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.textPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type.icon,
              size: 14,
              color: isActive ? AppColors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            AppText(
              type.label,
              style: TextStyle(
                fontSize: AppDimensions.fontS,
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

