import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'taxi_app_model.dart';
import 'taxi_providers_datasource.dart';

/// Fetches the provider list once.  Consumers that only need to display data
/// (e.g. the drawer header count) can watch this instead of the full notifier.
final taxiProvidersRemoteProvider = FutureProvider<List<TaxiApp>>((ref) {
  return const TaxiProvidersRemoteDatasource().fetchProviders();
});

