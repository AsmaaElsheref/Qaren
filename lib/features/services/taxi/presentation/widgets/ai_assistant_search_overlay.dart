import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_colors_ext.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../providers/aiAssistant/ai_assistant_notifier.dart';
import '../providers/aiAssistant/ai_assistant_providers.dart';

/// Floating AI-assistant search field shown over the map.
///
/// Visibility is controlled by [aiAssistantVisibilityProvider].
/// Typing only mutates [aiAssistantPromptProvider] — the map and bottom sheet
/// do not rebuild.
///
/// On submit, the prompt is parsed by [AiAssistantNotifier] into pickup /
/// destination coordinates. Those are written to the SAME providers used by
/// the manual flow, so [TaxiMapView] animates and [PickupField] /
/// [DestinationField] update automatically. No navigation is performed here.
class AiAssistantSearchOverlay extends ConsumerStatefulWidget {
  const AiAssistantSearchOverlay({super.key});

  @override
  ConsumerState<AiAssistantSearchOverlay> createState() =>
      AiAssistantSearchOverlayState();
}

class AiAssistantSearchOverlayState
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

  Future<void> _onSend() async {
    final prompt = _controller.text;
    // Persist prompt so it survives rebuilds and can be edited after errors.
    ref.read(aiAssistantPromptProvider.notifier).state = prompt;
    FocusScope.of(context).unfocus();
    await ref.read(aiAssistantNotifierProvider.notifier).submit(prompt);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.paddingM,
          80,
          AppDimensions.paddingM,
          0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                AiAssistantSendButton(onTap: _onSend),
                const SizedBox(width: AppDimensions.paddingS),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusL),
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
                      onChanged: (v) {
                        ref.read(aiAssistantPromptProvider.notifier).state = v;
                        ref
                            .read(aiAssistantNotifierProvider.notifier)
                            .clearError();
                      },
                      style:
                          TextStyle(color: colors.textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                        hintText: 'من أين تبدأ رحلتك وإلى أين؟',
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
            const AiAssistantErrorMessage(),
          ],
        ),
      ),
    );
  }
}

/// Send / loading button. Watches only the loading flag so the rest of the
/// overlay never rebuilds while typing.
class AiAssistantSendButton extends ConsumerWidget {
  const AiAssistantSendButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(aiAssistantLoadingProvider);
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isLoading
              ? AppColors.primary.withOpacity(0.6)
              : AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
      ),
    );
  }
}

/// Inline error row shown directly under the input. Watches only the error
/// provider so typing/loading does not rebuild it.
class AiAssistantErrorMessage extends ConsumerWidget {
  const AiAssistantErrorMessage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final error = ref.watch(aiAssistantErrorProvider);
    if (error == null || error.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.paddingS),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(color: AppColors.error.withOpacity(0.4)),
        ),
        child: AppText(
          error,
          style: const TextStyle(
            color: AppColors.error,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
