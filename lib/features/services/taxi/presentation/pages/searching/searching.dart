import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppButton.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import '../../../../../../core/constants/app_images.dart';
import '../../../../../../core/theme/app_colors_ext.dart';
import '../../../../../../core/ui/widgets/custom_app_bar.dart';
import '../../../domain/entities/car_rental_search_params.dart';
import '../../providers/comparePricesProvider/compare_prices_provider.dart';
import '../../providers/taxi_notifier.dart';
import '../../../../../profile/presentation/providers/profileSettings/profile_settings_provider.dart';
import 'search_loading_dialog.dart';

class Searching extends ConsumerWidget {
  const Searching({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(profileIsDarkModeProvider);
    final colors = context.appColors;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          bottom: false,
          child: CustomAppBar(isBack: true,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
        child: Column(
          children: [
            isDarkMode
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: context.screenHeight*0.1,),
                    Icon(
                      Icons.directions_car_rounded,
                      size: 72,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 30),
                    AppText(
                      'جاري البحث عن كباتن...',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                )
                : Image.asset(AppImages.searching),
            Spacer(),
            AppButton(label: "عرض النتائج", onTap: () async {
              // Build search params from taxi state
              final taxiState = ref.read(taxiProvider);
              final params = CarRentalSearchParams(
                pickupLat: taxiState.pickupLatLng!.latitude,
                pickupLng: taxiState.pickupLatLng!.longitude,
                dropoffLat: taxiState.destinationLatLng!.latitude,
                dropoffLng: taxiState.destinationLatLng!.longitude,
              );

              // Trigger search API call
              ref.read(comparePricesProvider.notifier).search(params);

              // Show loading dialog (waits for API completion)
              await SearchLoadingDialog.show(context);

            }),
            SizedBox(height: context.screenHeight*0.1,)
          ],
        ),
      ),
    );
  }
}
