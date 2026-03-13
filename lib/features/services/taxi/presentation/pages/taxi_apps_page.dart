import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppButton.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../providers/taxi_apps/taxi_apps_notifier.dart';
import '../widgets/taxi_app_tile.dart';
import '../widgets/taxi_top_bar.dart';

class TaxiAppsPage extends ConsumerWidget {
  const TaxiAppsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taxiAppsProvider);
    final notifier = ref.read(taxiAppsProvider.notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // ── Top bar ──────────────────────────────────────────────────
                const TaxiTopBar(),

                // ── Title ────────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.paddingM,
                    AppDimensions.paddingS,
                    AppDimensions.paddingM,
                    AppDimensions.paddingM,
                  ),
                  child: AppText(
                    'تطبيقات التوصيل',
                    style: const TextStyle(
                      fontSize: AppDimensions.fontXL,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // ── Counters row ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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

                // ── Select all / Cancel row ───────────────────────────────────
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

                // ── Apps list ─────────────────────────────────────────────────
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

                // ── Confirm button ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  child: AppButton(
                    label: 'تم',
                    icon: Icons.check_rounded,
                    onTap: state.selectedCount > 0
                        ? () => Navigator.of(context).pop(state.selectedIds)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Small helpers (private, no logic) ────────────────────────────────────────

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
          color: isPrimary ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        child: AppText(
          label,
          style: TextStyle(
            fontSize: AppDimensions.fontS,
            fontWeight: FontWeight.w600,
            color: isPrimary ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

