import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';

/// "رأي قارن الذكي" suggestion card shown at the top of the results.
class AiSuggestionCard extends StatelessWidget {
  const AiSuggestionCard({super.key, required this.suggestion});

  final String suggestion;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── AI icon badge ────────────────────────────────────────────────
          const _AiBadge(),

          const SizedBox(width: AppDimensions.paddingM),

          // ── Suggestion text ──────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  'رأي قارن الذكي',
                  style: TextStyle(
                    fontSize: AppDimensions.fontS,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                AppText(
                  suggestion,
                  secondary: true,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontS,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private ───────────────────────────────────────────────────────────────────

class _AiBadge extends StatelessWidget {
  const _AiBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: const Icon(
        Icons.auto_awesome_rounded,
        color: AppColors.white,
        size: AppDimensions.iconS,
      ),
    );
  }
}

