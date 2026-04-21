import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppButton.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';

import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../../../../core/ui/widgets/custom_app_bar.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../pages/food_result.dart';
import '../../providers/food_providers.dart';

/// Loading / searching screen shown while the compare API is in flight.
/// The "عرض النتائج" button is disabled until the API responds.
class Searching extends ConsumerWidget {
  const Searching({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(foodCompareIsLoadingProvider);
    final hasError  = ref.watch(foodCompareErrorProvider) != null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          bottom: false,
          child: CustomAppBar(isBack: true),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Image.asset(AppImages.foodLoading),
            const Spacer(),

            // Status hint while loading
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: AppDimensions.paddingM),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 8),
                    AppText(
                      'جارٍ البحث عن أفضل العروض...',
                      secondary: true,
                      style: TextStyle(fontSize: AppDimensions.fontS),
                    ),
                  ],
                ),
              ),

            if (hasError && !isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: AppDimensions.paddingM),
                child: AppText(
                  'حدث خطأ أثناء جلب النتائج، يمكنك المحاولة مجدداً',
                  secondary: true,
                  style: TextStyle(
                    fontSize: AppDimensions.fontS,
                    color: Color(0xFFE85D5D),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            AppButton(
              label: 'عرض النتائج',
              isLoading: isLoading,
              onTap: isLoading
                  ? null
                  : () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FoodResult(),
                        ),
                      ),
            ),
            SizedBox(height: context.screenHeight * 0.1),
          ],
        ),
      ),
    );
  }
}