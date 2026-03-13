import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppButton.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../providers/taxi_apps/taxi_apps_notifier.dart';
import 'taxi_app_tile.dart';

/// Slide-in end-drawer that shows the taxi apps selection panel.
/// Pure UI — all logic lives in [TaxiAppsNotifier].
class TaxiAppsDrawer extends ConsumerWidget {
  const TaxiAppsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taxiAppsProvider);
    final notifier = ref.read(taxiAppsProvider.notifier);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Drawer(
        width: MediaQuery.sizeOf(context).width * 0.88,
        backgroundColor: AppColors.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(AppDimensions.radiusXL),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.paddingM,
                  AppDimensions.paddingM,
                  AppDimensions.paddingM,
                  AppDimensions.paddingS,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: AppText(
                        'تطبيقات التوصيل',
                        style: const TextStyle(
                          fontSize: AppDimensions.fontL,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    // Close button
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: AppDimensions.iconS,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Counters ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                ),
                child: Row(
                  children: [
                    _CounterChip(
                      label: 'محدد: ${state.selectedCount}',
                      active: true,
                    ),
                    const SizedBox(width: AppDimensions.paddingS),
                    _CounterChip(
                      label: 'غير محدد: ${state.unselectedCount}',
                      active: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingM),

              // ── Select all / Clear ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                ),
                child: Row(
                  children: [
                    _ActionChip(
                      label: 'تحديد الكل',
                      onTap: notifier.selectAll,
                      isPrimary: true,
                    ),
                    const SizedBox(width: AppDimensions.paddingS),
                    _ActionChip(
                      label: 'إلغاء',
                      onTap: notifier.clearAll,
                      isPrimary: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingM),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: AppDimensions.paddingS),

              // ── Apps list ────────────────────────────────────────────────────
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM,
                  ),
                  itemCount: state.apps.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppDimensions.paddingS),
                  itemBuilder: (_, index) {
                    final app = state.apps[index];
                    return TaxiAppTile(
                      app: app,
                      isSelected: state.isSelected(app.id),
                      onTap: () => notifier.toggle(app.id),
                    );
                  },
                ),
              ),

              // ── Confirm button ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                child: AppButton(
                  label: 'تم',
                  icon: Icons.check_rounded,
                  onTap: state.selectedCount > 0
                      ? () => Navigator.of(context).pop()
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Private helpers ───────────────────────────────────────────────────────────

class _CounterChip extends StatelessWidget {
  final String label;
  final bool active;
  const _CounterChip({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingS,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: active ? AppColors.primaryLight : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: AppText(
        label,
        style: TextStyle(
          fontSize: AppDimensions.fontS,
          fontWeight: FontWeight.w600,
          color: active ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  const _ActionChip({
    required this.label,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primaryLight : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        child: AppText(
          label,
          style: TextStyle(
            fontSize: AppDimensions.fontS,
            fontWeight: FontWeight.w600,
            color: isPrimary ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

