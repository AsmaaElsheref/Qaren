import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/icon_container.dart';
import '../providers/aiAssistant/ai_assistant_providers.dart';
import '../providers/taxi_apps/taxi_apps_notifier.dart';

/// Top bar for [TaxiPage].
/// Converted to [ConsumerWidget] so the menu button can show a live badge
/// with the number of currently selected taxi providers.
class TaxiTopBar extends ConsumerWidget {
  const TaxiTopBar({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    // Only rebuild when selectedCount changes — not on every taxi state change.
    final selectedCount = ref.watch(
      taxiAppsProvider.select((s) => s.selectedCount),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ── Back button ────────────────────────────────────────────────
            IconContainer(
              onTap: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_rounded,
                color: colors.textPrimary,
                size: AppDimensions.iconM,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingS),

            // ── Menu button with provider count badge ──────────────────────
            _MenuButtonWithBadge(
              count: selectedCount,
              onTap: onMenuTap ?? () {},
              colors: colors,
            ),

            const Spacer(),

            // ── AI / magic button ──────────────────────────────────────────
            IconContainer(
              onTap: () {
                final notifier =
                    ref.read(aiAssistantVisibilityProvider.notifier);
                notifier.state = !notifier.state;
              },
              icon: const Icon(
                Icons.auto_awesome_outlined,
                color: AppColors.primary,
                size: AppDimensions.iconM,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Menu icon button with an animated count badge in the top-right corner.
/// Extracted to its own class (one class per file rule — this file owns
/// TaxiTopBar, and this is its sole private detail widget kept here for
/// locality; it is not exported).
class _MenuButtonWithBadge extends StatelessWidget {
  const _MenuButtonWithBadge({
    required this.count,
    required this.onTap,
    required this.colors,
  });

  final int count;
  final VoidCallback onTap;
  final dynamic colors; // AppColorTokens

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconContainer(
          onTap: onTap,
          icon: Icon(
            Icons.menu_rounded,
            color: colors.textPrimary,
            size: AppDimensions.iconM,
          ),
        ),
        if (count > 0)
          Positioned(
            top: -4,
            right: -4,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Container(
                key: ValueKey(count),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: colors.card, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
