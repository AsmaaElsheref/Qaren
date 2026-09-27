import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../widgets/comparison/comparison_filter_chips.dart';
import '../../widgets/comparison/comparison_header.dart';
import '../../widgets/comparison/comparison_info_card.dart';
import '../comparisonPage/comparison_page.dart';

class FoodResult extends StatelessWidget {
  const FoodResult({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.paddingS),
              ComparisonHeader(
                from: 'food.checkout.restaurantSection'.tr(),
                to: 'food.invoice.yourLocation'.tr(),
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: AppDimensions.paddingM),
                    const ComparisonInfoCard(),
                    const SizedBox(height: AppDimensions.paddingM),
                    const ComparisonFilterChips(),
                    const SizedBox(height: AppDimensions.paddingM),
                    const Expanded(child: FoodResultItems()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
