import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_colors_ext.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../../domain/entities/ai_search_params.dart';
import '../pages/searching/search_loading_dialog.dart';
import '../pages/searching/searching.dart';
import '../providers/aiAssistant/ai_assistant_providers.dart';
import '../providers/comparePricesProvider/compare_prices_provider.dart';
import '../providers/currentLocationProvider/current_location_provider.dart';

/// Floating AI-assistant search field shown over the map.
///
/// Visibility is controlled by [aiAssistantVisibilityProvider].
/// Typing only mutates [aiAssistantPromptProvider] — the map and bottom sheet
/// do not rebuild.
class AiAssistantSearchOverlay extends ConsumerStatefulWidget {
  const AiAssistantSearchOverlay({super.key});

  @override
  ConsumerState<AiAssistantSearchOverlay> createState() =>
      _AiAssistantSearchOverlayState();
}

class _AiAssistantSearchOverlayState
    extends ConsumerState<AiAssistantSearchOverlay> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(aiAssistantPromptProvider),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Keep the text field in sync when the provider is reset externally
    // (e.g. on TaxiPage exit or after successful booking).
    ref.listenManual<String>(aiAssistantPromptProvider, (_, next) {
      if (next.isEmpty && _controller.text.isNotEmpty) {
        _controller.clear();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Send handler ───────────────────────────────────────────────────────────
  Future<void> _onSend() async {
    final prompt = _controller.text.trim();

    if (prompt.isEmpty) {
      _showSnack('اكتب طلبك أولًا');
      return;
    }

    // Read current location synchronously from the async-notifier value.
    final LatLng? current = ref
        .read(currentLocationProvider)
        .maybeWhen(data: (d) => d.currentLocation, orElse: () => null);

    if (current == null) {
      _showSnack('لم نتمكن من تحديد موقعك الحالي');
      return;
    }

    // Persist prompt + hide overlay.
    ref.read(aiAssistantPromptProvider.notifier).state = prompt;
    ref.read(aiAssistantVisibilityProvider.notifier).state = false;
    FocusScope.of(context).unfocus();

    // Navigate to the existing loading screen (mirrors the compare-prices flow).
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Searching()),
    );

    // Fire the AI search — the existing loading dialog & compare_prices screen
    // listen to comparePricesProvider and react automatically.
    ref.read(comparePricesProvider.notifier).aiSearch(
          AiSearchParams(
            prompt: prompt,
            currentLat: current.latitude,
            currentLng: current.longitude,
          ),
        );

    if (!mounted) return;
    await SearchLoadingDialog.show(context);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AppText(msg,style: TextStyle(color: AppColors.surface),),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.error,
      ),
    );
  }

  // ── UI ─────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.paddingM,
          80, // sit just below TaxiTopBar
          AppDimensions.paddingM,
          0,
        ),
        child: Row(
          children: [
            // ── Send button ───────────────────────────────────────────────
            GestureDetector(
              onTap: _onSend,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingS),

            // ── Input ─────────────────────────────────────────────────────
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.right,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _onSend(),
                  onChanged: (v) =>
                      ref.read(aiAssistantPromptProvider.notifier).state = v,
                  style: TextStyle(color: colors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    hintText: 'اكتب طلبك (مثال: للمطار)',
                    hintStyle: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

