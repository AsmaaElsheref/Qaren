import '../../../../../core/network/apiRoutes/api_routes.dart';
import '../../../../../core/network/dioHelper/dio_helper.dart';
import '../../../../../core/utils/print/custom_print.dart';
import '../../domain/entities/car_rental_search_params.dart';
import '../models/carRental/car_rental_search_result_model.dart';

abstract class CarRentalRemoteDataSource {
  Future<CarRentalSearchResultModel> searchOffers(
    CarRentalSearchParams params,
  );
}

class CarRentalRemoteDataSourceImpl implements CarRentalRemoteDataSource {
  const CarRentalRemoteDataSourceImpl();

  @override
  Future<CarRentalSearchResultModel> searchOffers(
    CarRentalSearchParams params,
  ) async {
    try {
      final response = await DioHelper.getData(
        url: ApiRoutes.carRentalSearch,
        query: params.toQueryParameters(),
      );

      final body = response.data as Map<String, dynamic>;
      return CarRentalSearchResultModel.fromJson(body);
    } catch (e) {
      customPrint('CarRental search error ===> $e', isError: true);
      rethrow;
    }
  }
}

