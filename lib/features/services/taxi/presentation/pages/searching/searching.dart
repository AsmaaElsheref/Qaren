import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppButton.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import '../../../../../../core/ui/widgets/custom_app_bar.dart';
import '../../../../../../core/ui/widgets/logo_loading.dart';
import '../../../domain/entities/car_rental_search_params.dart';
import '../../providers/comparePricesProvider/compare_prices_state.dart';
import '../../providers/comparePricesProvider/compare_prices_provider.dart';
import '../../providers/taxi_notifier.dart';
import '../comparePrices/compare_prices.dart';

class Searching extends ConsumerStatefulWidget {
  const Searching({super.key});

  @override
  ConsumerState<Searching> createState() => _SearchingState();
}

class _SearchingState extends ConsumerState<Searching> {
  bool _searchStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startSearch());
  }

  void _startSearch() {
    if (!mounted) return;

    final taxiState = ref.read(taxiProvider);
    final pickup = taxiState.pickupLatLng;
    final destination = taxiState.destinationLatLng;
    if (pickup == null || destination == null) return;

    setState(() => _searchStarted = true);
    ref
        .read(comparePricesProvider.notifier)
        .search(
          CarRentalSearchParams(
            pickupLat: pickup.latitude,
            pickupLng: pickup.longitude,
            dropoffLat: destination.latitude,
            dropoffLng: destination.longitude,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(comparePricesStatusProvider);
    final canShowResults =
        _searchStarted &&
        (status == ComparePricesStatus.success ||
            status == ComparePricesStatus.empty);
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
            // Icons.directions_car_rounded,
            // size: 72,
            // color: AppColors.primary,
            // ),
            // const SizedBox(height: 30),
            // AppText(
            // 'جاري البحث عن كباتن...',
            // style: TextStyle(
            // fontSize: 20,
            // fontWeight: FontWeight.w600,
            // color: colors.textPrimary,
            // ),
            // ),
            // ],
            // )
            // : Image.asset(AppImages.searching),
            LogoLoading(),
            const SizedBox(height: 30),
            AppText(
              'taxi.search.searchingDrivers'.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            Spacer(),
            AppButton(
              label: 'taxi.search.showResults'.tr(),
              onTap: canShowResults
                  ? () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ComparePricesPage(),
                      ),
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
