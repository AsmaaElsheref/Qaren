import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../providers/food_providers.dart';
import '../widgets/food_provider_card.dart';
import 'food_invoice_page.dart';

class foodResultItems extends ConsumerWidget {
  const foodResultItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providers = ref.watch(sortedFoodProvidersProvider);
    return SizedBox(
      height: context.screenHeight*0.59,
      child: ListView.builder(
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
        itemCount: providers.length,
      ),
    );
  }
}

