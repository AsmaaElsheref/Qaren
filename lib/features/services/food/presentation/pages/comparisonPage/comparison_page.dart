import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../domain/entities/food_provider_model.dart';
import '../../providers/food_providers.dart';
import '../../widgets/comparison/foodPartialSheet/food_partial_match_sheet.dart';
import '../../widgets/comparison/foodProviderCard/food_provider_card.dart';
import '../foodInvoicePage/food_invoice_page.dart';

/// Scrollable list of provider comparison cards.
/// Only rebuilds when [sortedFoodProvidersProvider] changes.
class FoodResultItems extends ConsumerWidget {
  const FoodResultItems({super.key});

  Future<void> _handleBook(
    BuildContext context,
    WidgetRef ref,
    FoodProviderModel provider,
  ) async {
    final isFullMatch = provider.totalRequested > 0 &&
        provider.matchedCount >= provider.totalRequested;

    if (!isFullMatch) {
      final cartMap        = ref.read(cartProductsNameMapProvider);
      final availableIds   = provider.productsPreview.map((p) => p.id).toSet();
      final availableNames = provider.productsPreview.map((p) => p.name).toList();
      final missingNames   = cartMap.entries
          .where((e) => !availableIds.contains(e.key))
          .map((e) => e.value)
          .toList();

      final confirmed = await FoodPartialMatchSheet.show(
        context,
        provider: provider,
        availableNames: availableNames,
        missingNames: missingNames,
      );
      if (confirmed != true || !context.mounted) return;
    }

    // Set the selected provider so the invoice page can derive real data.
    ref.read(selectedProviderForBookingProvider.notifier).state = provider;

    // Fetch full invoice detail from API — invoice page shows shimmer meanwhile.
    final cartItems = ref.read(foodCartItemsProvider);
    final productIds =
        cartItems.map((item) => int.tryParse(item.id) ?? 0).toList();
    final location = ref.read(foodSelectedLocationProvider);

    ref.read(foodInvoiceDetailProvider.notifier).fetch(
          partnerId: int.tryParse(provider.id) ?? 0,
          productIds: productIds,
          userLat: location?.latitude ?? 0,
          userLng: location?.longitude ?? 0,
        );

    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FoodInvoicePage()),
    );
  }

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
        itemBuilder: (context, index) {
          final provider = providers[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            child: FoodProviderCard(
              provider: provider,
              onBook: () => _handleBook(context, ref, provider),
            ),
          );
        },
      ),
    );
  }
}
