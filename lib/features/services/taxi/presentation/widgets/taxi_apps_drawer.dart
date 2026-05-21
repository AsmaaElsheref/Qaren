import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_colors_ext.dart';
import '../../../../../core/ui/widgets/AppButton.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../../../../../core/ui/widgets/AppTextStyles.dart';
import '../providers/taxi_apps/taxi_apps_notifier.dart';
import 'taxi_action_chip.dart';
import 'taxi_app_tile.dart';
import 'taxi_counter_chip.dart';

/// Slide-in end-drawer that shows the taxi apps selection panel.
/// Pure UI — all logic lives in [TaxiAppsNotifier].
class TaxiAppsDrawer extends ConsumerWidget {
  const TaxiAppsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taxiAppsProvider);
    final notifier = ref.read(taxiAppsProvider.notifier);
    final colors = context.appColors;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Drawer(
        width: MediaQuery.sizeOf(context).width * 0.88,
        backgroundColor: colors.bottomSheetBackground,
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
                        style: AppTextStyles.title.copyWith(
                          fontSize: AppDimensions.fontL,
                          fontWeight: FontWeight.w800,
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: colors.iconBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: AppDimensions.iconS,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Loading indicator ────────────────────────────────────────
              if (state.isLoading)
                LinearProgressIndicator(
                  minHeight: 2,
                  color: AppColors.primary,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                ),

              // ── Counters ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                ),
                child: Row(
                  children: [
                    TaxiCounterChip(
                      label: 'محدد: ${state.selectedCount}',
                      active: true,
                    ),
                    const SizedBox(width: AppDimensions.paddingS),
                    TaxiCounterChip(
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
                    TaxiActionChip(
                      label: 'تحديد الكل',
                      onTap: notifier.selectAll,
                      isPrimary: true,
                    ),
                    const SizedBox(width: AppDimensions.paddingS),
                    TaxiActionChip(
                      label: 'إلغاء',
                      onTap: notifier.clearAll,
                      isPrimary: false,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.paddingM),
              Divider(height: 1, color: colors.divider),
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

