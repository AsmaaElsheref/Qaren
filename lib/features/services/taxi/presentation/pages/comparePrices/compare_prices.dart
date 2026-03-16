import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../widgets/comparePrices/ai_suggestion_card.dart';
import '../../widgets/comparePrices/compare_prices_app_bar.dart';
import '../../widgets/comparePrices/price_result_card.dart';
import '../../widgets/comparePrices/sort_tab_bar.dart';
import '../../providers/comparePricesProvider/compare_prices_provider.dart';

class ComparePricesPage extends ConsumerWidget {
  const ComparePricesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Column(
            children: [
              const ComparePricesAppBar(),
              const Expanded(child: _ContentList()),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentList extends ConsumerWidget {
  const _ContentList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(compareSortedResultsProvider);

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingM,
      ),
      children: [
        // ── AI suggestion ─────────────────────────────────────────────────
        const AiSuggestionCard(
          suggestion:
              'أنا قارن، للوصول إلى شارع الأمير سلطان بن سلمان، أرشح لك تطبيق '
              'أوبر لسرعة الاستجابة أو بولت إذا كنت تفضل السعر الأقل.',
        ),

        const SizedBox(height: AppDimensions.paddingM),

        // ── Sort tabs ──────────────────────────────────────────────────────
        const SortTabBar(),

        const SizedBox(height: AppDimensions.paddingM),

        // ── Result cards ───────────────────────────────────────────────────
        ...results.map(
          (result) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
            child: PriceResultCard(
              result: result,
              onBook: () {
                // TODO: open booking flow for result.id
              },
            ),
          ),
        ),
      ],
    );
  }
}

