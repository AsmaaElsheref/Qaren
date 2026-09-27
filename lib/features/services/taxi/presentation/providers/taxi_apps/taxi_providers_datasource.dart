import '../../../../../../core/network/apiRoutes/api_routes.dart';
import '../../../../../../core/network/dioHelper/dio_helper.dart';
import '../../../../../../core/utils/print/custom_print.dart';
import 'taxi_app_icon_resolver.dart';
import 'taxi_app_model.dart';

/// Fetches the list of supported taxi providers from the server and maps
/// each entry to the local [TaxiApp] presentation model.
class TaxiProvidersRemoteDatasource {
  const TaxiProvidersRemoteDatasource();

  Future<List<TaxiApp>> fetchProviders() async {
    try {
      final response = await DioHelper.getData(
        url: ApiRoutes.carRentalProviders,
      );
      final body = response.data as Map<String, dynamic>;
      final data = body['data'];
      final dataList = data is Map<String, dynamic>
          ? data['providers'] as List<dynamic>? ?? const []
          : data as List<dynamic>? ?? const [];

      return dataList
          .where((e) {
            final json = e as Map<String, dynamic>;
            return json['is_active'] != false;
          })
          .map((e) {
            final json = e as Map<String, dynamic>;
            final slug = json['slug'] as String? ?? '';
            final providerId = json['provider_id']?.toString() ?? slug;
            final name = json['name'] as String? ?? slug;
            final rating = (json['rating'] as num?)?.toDouble() ?? 0.0;

            return TaxiApp(
              id: providerId,
              name: name,
              logoUrl: json['logo_url'] as String?,
              description: rating > 0 ? '⭐ $rating' : '',
              iconBgColor: TaxiAppIconResolver.bgColorFor(slug),
              iconColor: TaxiAppIconResolver.iconColorFor(slug),
              icon: TaxiAppIconResolver.iconFor(slug),
            );
          })
          .toList();
    } catch (e) {
      customPrint('TaxiProviders fetch error: $e', isError: true);
      rethrow;
    }
  }
}
