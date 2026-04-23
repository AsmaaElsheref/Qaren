import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
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
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.paddingS),
                const ComparisonHeader(from: 'مطعم وجبة', to: 'المنزل'),
                Column(
                  children: [
                    const SizedBox(height: AppDimensions.paddingM),
                    const ComparisonInfoCard(),
                    const SizedBox(height: AppDimensions.paddingM),
                    const ComparisonFilterChips(),
                    const SizedBox(height: AppDimensions.paddingM),
                    const FoodResultItems()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}