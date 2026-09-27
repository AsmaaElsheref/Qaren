import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/localization/easy_localization.dart';

import '../../../domain/entities/ai_search_params.dart';
import '../comparePricesProvider/compare_prices_provider.dart';
import '../comparePricesProvider/compare_prices_state.dart';
import '../currentLocationProvider/current_location_provider.dart';
import 'ai_assistant_providers.dart';
import 'ai_assistant_state.dart';

/// Submits the AI-assistant prompt and stores the returned cars in the same
/// comparison state used by the regular taxi search.
class AiAssistantNotifier extends Notifier<AiAssistantState> {
  @override
  AiAssistantState build() => const AiAssistantState();

  /// Resets the overlay state but does not touch pickup/destination.
  void reset() => state = const AiAssistantState();

  /// Returns `true` when the API completed successfully, including an empty
  /// result set. The caller can then navigate to the comparison screen.
  Future<bool> submit(String rawPrompt) async {
    final prompt = rawPrompt.trim();

    if (prompt.isEmpty) {
      state = state.copyWith(errorMessage: 'taxi.ai.enterPromptFirst'.tr());
      return false;
    }

    final current = ref
        .read(currentLocationProvider)
        .maybeWhen(data: (d) => d.currentLocation, orElse: () => null);

    if (current == null) {
      state = state.copyWith(errorMessage: 'taxi.ai.locationFailed'.tr());
      return false;
    }

    state = const AiAssistantState(isLoading: true);

    await ref
        .read(comparePricesProvider.notifier)
        .aiSearch(
          AiSearchParams(
            prompt: prompt,
            currentLat: current.latitude,
            currentLng: current.longitude,
          ),
        );

    final compareState = ref.read(comparePricesProvider);
    final succeeded =
        compareState.status == ComparePricesStatus.success ||
        compareState.status == ComparePricesStatus.empty;

    if (!succeeded) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: compareState.errorMessage ?? 'taxi.ai.parseFailed'.tr(),
      );
      return false;
    }

    ref.read(aiAssistantVisibilityProvider.notifier).state = false;
    ref.read(aiAssistantPromptProvider.notifier).state = '';
    state = const AiAssistantState();
    return true;
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(clearError: true);
    }
  }
}

final aiAssistantNotifierProvider =
    NotifierProvider<AiAssistantNotifier, AiAssistantState>(
      AiAssistantNotifier.new,
    );

/// Granular — only the loading flag (rebuilds send button only).
final aiAssistantLoadingProvider = Provider<bool>(
  (ref) => ref.watch(aiAssistantNotifierProvider.select((s) => s.isLoading)),
);

/// Granular — only the error message (rebuilds error row only).
final aiAssistantErrorProvider = Provider<String?>(
  (ref) => ref.watch(aiAssistantNotifierProvider.select((s) => s.errorMessage)),
);
