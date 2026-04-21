import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../providers/food_providers.dart';
import '../widgets/food_provider_card.dart';
import 'food_invoice_page.dart';

/// Scrollable list of provider comparison cards.
/// Only rebuilds when [sortedFoodProvidersProvider] changes.
class FoodResultItems extends ConsumerWidget {
  const FoodResultItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(foodCompareIsLoadingProvider);
    final error     = ref.watch(foodCompareErrorProvider);
    final providers = ref.watch(sortedFoodProvidersProvider);

    if (isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (error != null) {
      return Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Center(
          child: AppText(
            'حدث خطأ: $error',
            secondary: true,
            style: const TextStyle(fontSize: AppDimensions.fontS),
          ),
        ),
      );
    }

    if (providers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Center(
          child: AppText(
            'لا توجد نتائج',
            secondary: true,
            style: TextStyle(fontSize: AppDimensions.fontM),
          ),
        ),
      );
    }

    return SizedBox(
      height: context.screenHeight * 0.59,
      child: ListView.builder(
        itemCount: providers.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          child: FoodProviderCard(
            provider: providers[index],
            onBook: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const FoodInvoicePage(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
