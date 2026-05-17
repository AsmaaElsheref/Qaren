import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/ui/widgets/loading.dart';
import 'package:qaren/features/services/taxi/presentation/providers/currentLocationProvider/current_location_provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../providers/taxi_providers.dart';
import '../widgets/taxi_apps_drawer.dart';
import '../widgets/taxi_map_view.dart';
import '../widgets/taxi_top_bar.dart';
import '../widgets/location_sheet.dart';

class TaxiPage extends ConsumerStatefulWidget {
  const TaxiPage({super.key});

  @override
  ConsumerState<TaxiPage> createState() => _TaxiPageState();
}

class _TaxiPageState extends ConsumerState<TaxiPage> {
  TaxiResetController? _resetController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resetController ??= ref.read(taxiResetControllerProvider);
  }

  @override
  void dispose() {
    _resetController?.resetOnTaxiPageExit();
    _resetController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final curLocationState = ref.watch(currentLocationProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: false,
        drawer: const TaxiAppsDrawer(),
        body: Builder(
          builder: (innerContext) {
            void openAppsDrawer() => Scaffold.of(innerContext).openDrawer();
            return curLocationState.when(
              loading: () => Stack(
                children: [
                  const Loading(),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: TaxiTopBar(onMenuTap: openAppsDrawer),
                  ),
                ],
              ),
              error: (error, stack) => Stack(
                children: [
                  Center(child: Text(error.toString())),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: TaxiTopBar(onMenuTap: openAppsDrawer),
                  ),
                ],
              ),
              data: (_) => Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        const RepaintBoundary(child: TaxiMapView()),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: TaxiTopBar(onMenuTap: openAppsDrawer),
                        ),
                      ],
                    ),
                  ),
                  const LocationSheet(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

}

