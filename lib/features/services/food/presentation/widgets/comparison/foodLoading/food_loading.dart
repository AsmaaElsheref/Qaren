import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/localization/easy_localization.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppButton.dart';
import 'package:qaren/core/ui/widgets/logo_loading.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';

import '../../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../../core/ui/widgets/AppText.dart';
import '../../../../../../../core/ui/widgets/custom_app_bar.dart';
import '../../../pages/foodResult/food_result.dart';
import '../../../providers/food_comparison_provider.dart';

/// Loading / searching screen shown while the compare API is in flight.
/// The "عرض النتائج" button is disabled until the API responds.
class Searching extends ConsumerWidget {
  const Searching({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compareState = ref.watch(foodCompareNotifierProvider);
    final isLoading = compareState.isLoading;
    final hasError = compareState.error != null;
    final canShowResults = compareState.hasCompleted && !hasError;
    final colors = context.appColors;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(bottom: false, child: CustomAppBar(isBack: true)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            // isDarkMode
            // ? Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // children: [
            // SizedBox(height: context.screenHeight*0.1,),
            // Icon(
            // Icons.directions_bike,
            // size: 72,
            // color: AppColors.primary,
            // ),
            // const SizedBox(height: 30),
            // AppText(
            // 'جاري البحث في التطبيقات...',
            // style: TextStyle(
            // fontSize: 20,
            // fontWeight: FontWeight.w600,
            // color: colors.textPrimary,
            // ),
            // ),
            // ],
            // )
            // : Image.asset(AppImages.foodLoading),
            LogoLoading(),
            const SizedBox(height: 30),
            AppText(
              'food.comparison.searchingApps'.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const Spacer(),

            // Status hint while loading
            if (isLoading)
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppText(
                      'food.comparison.searchingOffers'.tr(),
                      secondary: true,
                      style: const TextStyle(fontSize: AppDimensions.fontS),
                    ),
                  ],
                ),
              ),

            if (hasError && !isLoading)
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
                child: AppText(
                  'food.comparison.fetchError'.tr(),
                  secondary: true,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontS,
                    color: Color(0xFFE85D5D),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            AppButton(
              label: 'food.comparison.showResults'.tr(),
              onTap: canShowResults
                  ? () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const FoodResult()),
                    )
                  : null,
            ),
            SizedBox(height: context.screenHeight * 0.1),
          ],
        ),
      ),
    );
  }
}
