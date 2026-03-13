import 'taxi_app_model.dart';

/// Immutable state for the taxi-apps selection screen.
class TaxiAppsState {
  /// Ordered list of all available apps.
  final List<TaxiApp> apps;

  /// IDs of the currently selected apps.
  final Set<String> selectedIds;

  const TaxiAppsState({
    required this.apps,
    required this.selectedIds,
  });

  /// All apps are selected.
  bool get allSelected => selectedIds.length == apps.length;

  /// Number of selected apps.
  int get selectedCount => selectedIds.length;

  /// Number of unselected apps.
  int get unselectedCount => apps.length - selectedIds.length;

  bool isSelected(String id) => selectedIds.contains(id);

  TaxiAppsState copyWith({
    List<TaxiApp>? apps,
    Set<String>? selectedIds,
  }) =>
      TaxiAppsState(
        apps: apps ?? this.apps,
        selectedIds: selectedIds ?? this.selectedIds,
      );
}

