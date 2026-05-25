import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/car_rental_remote_datasource.dart';
import '../../../data/repositories/car_rental_repository_impl.dart';
import '../../../domain/entities/ai_search_params.dart';
import '../../../domain/repositories/car_rental_repository.dart';
import '../../../domain/usecases/ai_search_car_rental_usecase.dart';
import '../currentLocationProvider/current_location_provider.dart';
import '../taxi_notifier.dart';
import 'ai_assistant_providers.dart';
import 'ai_assistant_state.dart';

// ── Private data-layer providers (kept local to AI assistant) ───────────────
final _aiRemoteDataSourceProvider = Provider<CarRentalRemoteDataSource>(
  (ref) => const CarRentalRemoteDataSourceImpl(),
);

final _aiRepositoryProvider = Provider<CarRentalRepository>(
  (ref) => CarRentalRepositoryImpl(ref.watch(_aiRemoteDataSourceProvider)),
);

final _aiSearchUseCaseProvider = Provider<AiSearchCarRentalUseCase>(
  (ref) => AiSearchCarRentalUseCase(ref.watch(_aiRepositoryProvider)),
);

/// Submits the AI-assistant prompt to `/api/compare/car-rental/ai-search`
/// **only** to parse pickup/destination. The actual price-comparison call
/// still happens when the user taps "مقارنة الأسعار" on [LocationSheet].
class AiAssistantNotifier extends Notifier<AiAssistantState> {
  @override
  AiAssistantState build() => const AiAssistantState();

  /// Resets the overlay state but does not touch pickup/destination.
  void reset() => state = const AiAssistantState();

  /// Submit prompt and fill pickup/destination providers on success.
  Future<void> submit(String rawPrompt) async {
    final prompt = rawPrompt.trim();

    if (prompt.isEmpty) {
      state = state.copyWith(errorMessage: 'اكتب طلبك أولًا');
      return;
    }

    final current = ref.read(currentLocationProvider).maybeWhen(
          data: (d) => d.currentLocation,
          orElse: () => null,
        );

    if (current == null) {
      state = state.copyWith(
        errorMessage: 'لم نتمكن من تحديد موقعك الحالي',
      );
      return;
    }

    state = const AiAssistantState(isLoading: true);

    final result = await ref.read(_aiSearchUseCaseProvider).call(
          AiSearchParams(
            prompt: prompt,
            currentLat: current.latitude,
            currentLng: current.longitude,
          ),
        );

    await result.fold(
      (failure) async {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'لم نتمكن من فهم الطلب، حاول مرة أخرى',
        );
      },
      (data) async {
        final parsed = data.parsedParameters;
        if (parsed == null || parsed.pickup == null || parsed.dropoff == null) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: 'لم نتمكن من فهم الطلب، حاول مرة أخرى',
          );
          return;
        }

        // Fill the SAME providers used by the normal manual flow.
        // TaxiMapView listens to taxiPickupLocationProvider /
        // taxiDestinationLocationProvider (both derived from taxiProvider)
        // and animates / fits the camera automatically.
        await ref.read(taxiProvider.notifier).fillFromParsedParameters(
              parsed,
              aiDestinationName: parsed.destinationName,
              overwrite: true,
            );

        // Hide the overlay and clear its transient state.
        ref.read(aiAssistantVisibilityProvider.notifier).state = false;
        ref.read(aiAssistantPromptProvider.notifier).state = '';
        state = const AiAssistantState();
      },
    );
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
  (ref) =>
      ref.watch(aiAssistantNotifierProvider.select((s) => s.isLoading)),
);

/// Granular — only the error message (rebuilds error row only).
final aiAssistantErrorProvider = Provider<String?>(
  (ref) =>
      ref.watch(aiAssistantNotifierProvider.select((s) => s.errorMessage)),
);

