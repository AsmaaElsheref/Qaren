import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'taxi_app_model.dart';
import 'taxi_apps_state.dart';

/// Owns all mutations for [TaxiAppsState]. Zero UI / BuildContext.
class TaxiAppsNotifier extends Notifier<TaxiAppsState> {
  @override
  TaxiAppsState build() => TaxiAppsState(
        apps: kTaxiApps,
        // All selected by default.
        selectedIds: kTaxiApps.map((a) => a.id).toSet(),
      );

  /// Toggle a single app on / off.
  void toggle(String id) {
    final current = Set<String>.from(state.selectedIds);
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    state = state.copyWith(selectedIds: current);
  }

  /// Select every app.
  void selectAll() => state = state.copyWith(
        selectedIds: state.apps.map((a) => a.id).toSet(),
      );

  /// Deselect every app.
  void clearAll() => state = state.copyWith(selectedIds: {});
}

final taxiAppsProvider =
    NotifierProvider<TaxiAppsNotifier, TaxiAppsState>(TaxiAppsNotifier.new);

