import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/ui/widgets/loading.dart';
import 'package:qaren/features/services/taxi/presentation/providers/currentLocationProvider/current_location_provider.dart';
import '../providers/aiAssistant/ai_assistant_providers.dart';
import '../providers/taxi_providers.dart';
import '../widgets/ai_assistant_search_overlay.dart';
import '../widgets/taxi_apps_drawer.dart';
import '../widgets/taxi_map_view.dart';
import '../widgets/taxi_top_bar.dart';
import '../widgets/location_sheet.dart';
import '../widgets/route/route_info_card.dart';

class TaxiPage extends ConsumerStatefulWidget {
  const TaxiPage({super.key});

  @override
  ConsumerState<TaxiPage> createState() => _TaxiPageState();
}

class _TaxiPageState extends ConsumerState<TaxiPage> {
  TaxiResetController? _resetController;
  int _appsDrawerKey = 0;

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
    ref.watch(routeSyncProvider);

    final curLocationState = ref.watch(currentLocationProvider);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: TaxiAppsDrawer(key: ValueKey(_appsDrawerKey)),
        body: Builder(
          builder: (innerContext) {
            void openAppsDrawer() {
              setState(() => _appsDrawerKey++);
              Scaffold.of(innerContext).openDrawer();
            }
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
                        // ── AI assistant overlay ───────────────────────────
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Consumer(
                            builder: (_, ref, __) {
                              final visible = ref
                                  .watch(aiAssistantVisibilityProvider);
                              if (!visible) return const SizedBox.shrink();
                              return const AiAssistantSearchOverlay();
                            },
                          ),
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

