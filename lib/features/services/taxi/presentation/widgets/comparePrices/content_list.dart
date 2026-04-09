import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import 'package:qaren/features/services/taxi/presentation/widgets/comparePrices/sort_tab_bar.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../pages/tripDetails/trip_details.dart';
import '../../providers/comparePricesProvider/compare_prices_provider.dart';
import '../../providers/comparePricesProvider/compare_prices_state.dart';
import 'ai_suggestion_card.dart';
import 'price_result_card.dart';

class ContentList extends ConsumerWidget {
  const ContentList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(comparePricesStatusProvider);
    final results = ref.watch(compareSortedResultsProvider);

    return switch (status) {
      ComparePricesStatus.initial ||
      ComparePricesStatus.loading => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ComparePricesStatus.failure => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.textHint),
              const SizedBox(height: AppDimensions.paddingM),
              AppText(
                ref.watch(comparePricesProvider).errorMessage ?? 'حدث خطأ. حاول مرة أخرى.',
                textAlign: TextAlign.center,
                secondary: true,
              ),
            ],
          ),
        ),
      ComparePricesStatus.empty => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 48, color: AppColors.textHint),
              SizedBox(height: AppDimensions.paddingM),
              AppText(
                'لا توجد نتائج. جرب تغيير معايير البحث.',
                textAlign: TextAlign.center,
                secondary: true,
              ),
            ],
          ),
        ),
      ComparePricesStatus.success => ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingM,
          ),
          children: [
            const AiSuggestionCard(
              suggestion:
                  'أنا قارن، للوصول إلى شارع الأمير سلطان بن سلمان، أرشح لك تطبيق '
                  'أوبر لسرعة الاستجابة أو بولت إذا كنت تفضل السعر الأقل.',
            ),
            const SizedBox(height: AppDimensions.paddingM),
            const SortTabBar(),
            const SizedBox(height: AppDimensions.paddingM),
            SizedBox(
              height: context.screenHeight * 0.6,
              child: ListView.separated(
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TripDetails(serviceName: results[index].appName),
                    ),
                  ),
                  child: PriceResultCard(
                    result: results[index],
                    onBook: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TripDetails(serviceName: results[index].appName),
                        ),
                      );
                    },
                  ),
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppDimensions.paddingM),
                itemCount: results.length,
              ),
            ),
          ],
        ),
    };
  }
}