import '../../../../../core/network/apiRoutes/api_routes.dart';
import '../../../../../core/network/dioHelper/dio_helper.dart';
import '../../../../../core/utils/print/custom_print.dart';
import '../../domain/entities/food_item.dart';
import '../models/food_product_model.dart';

/// Remote data source that fetches food products from the API.
abstract class FoodRemoteDataSource {
  Future<List<FoodItem>> getProducts();
}

class FoodRemoteDataSourceImpl implements FoodRemoteDataSource {
  const FoodRemoteDataSourceImpl();

  @override
  Future<List<FoodItem>> getProducts() async {
    try {
      final response = await DioHelper.getData(
        url: ApiRoutes.foodProducts,
      );

      final body = response.data as Map<String, dynamic>;
      final dataList = body['data'] as List<dynamic>;

      return FoodProductModel.fromJsonList(dataList);
    } catch (e) {
      customPrint('Food products error ===> $e', isError: true);
      rethrow;
    }
  }
}

