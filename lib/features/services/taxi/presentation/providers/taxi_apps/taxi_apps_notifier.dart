import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'taxi_app_model.dart';
import 'taxi_apps_state.dart';
import 'taxi_providers_provider.dart';

class TaxiAppsNotifier extends Notifier<TaxiAppsState> {

  Set<String>? _selectedIds;

  @override
  TaxiAppsState build() {
    final asyncApps = ref.watch(taxiProvidersRemoteProvider);

    return asyncApps.when(
      loading: () => TaxiAppsState(
        apps: kTaxiApps,
        selectedIds: _selectedIds ?? kTaxiApps.map((a) => a.id).toSet(),
        isLoading: true,
      ),
      error: (_, __) => TaxiAppsState(
        apps: kTaxiApps,
        selectedIds: _selectedIds ?? kTaxiApps.map((a) => a.id).toSet(),
        isLoading: false,
      ),
      data: (apps) {
        final allIds = apps.map((a) => a.id).toSet();
        // First time data arrives: select everything.
        if (_selectedIds == null) {
          _selectedIds = Set.from(allIds);
        } else {
          // Keep only IDs still returned by the server.
          final preserved = _selectedIds!.intersection(allIds);
          _selectedIds = preserved.isEmpty ? Set.from(allIds) : preserved;
        }
        return TaxiAppsState(
          apps: apps,
          selectedIds: Set.unmodifiable(_selectedIds!),
          isLoading: false,
        );
      },
    );
  }

  /// Toggle a single app on / off.
  void toggle(String id) {
    final current = Set<String>.from(state.selectedIds);
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    _selectedIds = current;
    state = state.copyWith(selectedIds: Set.unmodifiable(current));
  }

  /// Select every app.
  void selectAll() {
    final all = state.apps.map((a) => a.id).toSet();
    _selectedIds = all;
    state = state.copyWith(selectedIds: Set.unmodifiable(all));
  }

  /// Deselect every app.
  void clearAll() {
    _selectedIds = {};
    state = state.copyWith(selectedIds: const {});
  }

  /// Persist a selection after the user confirms (e.g. drawer "تم").
  void applySelection(Set<String> selectedIds) {
    final allIds = state.apps.map((a) => a.id).toSet();
    final valid = selectedIds.intersection(allIds);
    _selectedIds = valid.isEmpty && allIds.isNotEmpty
        ? Set.from(allIds)
        : Set.from(valid);
    state = state.copyWith(selectedIds: Set.unmodifiable(_selectedIds!));
  }
}

final taxiAppsProvider =
    NotifierProvider<TaxiAppsNotifier, TaxiAppsState>(TaxiAppsNotifier.new);
