import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'aiAssistant/ai_assistant_providers.dart';
import 'comparePricesProvider/compare_prices_provider.dart';
import 'offerDetailsProvider/offer_details_provider.dart';
import 'taxi_notifier.dart';

class TaxiResetController {
  const TaxiResetController(this._ref);

  final Ref _ref;

  void resetOnTaxiPageExit() {
    Future<void>(_resetSearchScopedState);
  }

  void resetAfterSuccessfulBooking() {
    _resetSearchScopedState();
  }

  void _resetSearchScopedState() {
    _ref.read(taxiProvider.notifier).resetTaxiSearchState();
    _ref.read(comparePricesProvider.notifier).reset();
    _ref.read(offerDetailsProvider.notifier).reset();
    // Clear AI assistant prompt and hide overlay.
    _ref.read(aiAssistantPromptProvider.notifier).state = '';
    _ref.read(aiAssistantVisibilityProvider.notifier).state = false;
  }
}

final taxiResetControllerProvider = Provider<TaxiResetController>(
  TaxiResetController.new,
);
