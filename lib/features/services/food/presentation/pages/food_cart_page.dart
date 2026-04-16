import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../providers/food_providers.dart';
import '../widgets/add_more_button.dart';
import '../widgets/cart_header.dart';
import '../widgets/cart_items_list.dart';
import '../widgets/compare_prices_button.dart';
import '../widgets/empty_cart_view.dart';
import '../widgets/order_summary_section.dart';

/// Cart / Order Summary screen.
///
/// This page only composes widgets — zero business logic.
/// Empty/filled switching is driven by [foodCartIsEmptyProvider].
class FoodCartPage extends ConsumerWidget {
  const FoodCartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmpty = ref.watch(foodCartIsEmptyProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.paddingS),
              const CartHeader(),
              const SizedBox(height: AppDimensions.paddingS),
              Expanded(
                child: isEmpty
                    ? const EmptyCartView()
                    : SingleChildScrollView(
                        child: Column(
                          children: const [
                            CartItemsList(),
                            SizedBox(height: AppDimensions.paddingM),
                            AddMoreButton(),
                            SizedBox(height: AppDimensions.paddingL),
                          ],
                        ),
                      ),
              ),
              const OrderSummarySection(),
              const ComparePricesButton(),
            ],
          ),
        ),
      ),
    );
  }
}

