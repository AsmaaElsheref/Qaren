import '../../../../../core/network/apiRoutes/api_routes.dart';
import '../../../../../core/network/dioHelper/dio_helper.dart';
import '../../../../../core/utils/print/custom_print.dart';
import '../../domain/entities/food_category.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/food_provider_model.dart';
import '../models/food_category_model.dart';
import '../models/food_compare_request_model.dart';
import '../models/food_compare_response_model.dart';
import '../models/food_product_model.dart';

/// Remote data source for the food delivery feature.
///
/// Responsibilities:
///  - Fetch all products (with optional server-side search & category filter)
///  - Fetch all categories
abstract class FoodRemoteDataSource {
  /// [search]     → `?search=`     query param (server-side full-text search)
  /// [categoryId] → `?category_id=` query param (server-side category filter)
  Future<List<FoodItem>> getProducts({String? search, String? categoryId});

  /// Fetches all food categories from the API.
  Future<List<FoodCategory>> getCategories();

  /// Compares products and returns the result.
  Future<List<FoodProviderModel>> compareProducts(FoodCompareRequestModel request);
}

class FoodRemoteDataSourceImpl implements FoodRemoteDataSource {
  const FoodRemoteDataSourceImpl();

  @override
  Future<List<FoodItem>> getProducts({
    String? search,
    String? categoryId,
  }) async {
    try {
      final query = <String, dynamic>{};
      if (search != null && search.isNotEmpty) query['search'] = search;
      if (categoryId != null && categoryId.isNotEmpty) {
        query['category_id'] = categoryId;
      }

      final response = await DioHelper.getData(
        url: ApiRoutes.foodProducts,
        query: query.isEmpty ? null : query,
      );

      final body     = response.data as Map<String, dynamic>;
      final dataList = body['data'] as List<dynamic>;
      return FoodProductModel.fromJsonList(dataList);
    } catch (e) {
      customPrint('Food products error ===> $e', isError: true);
      rethrow;
    }
  }

  @override
  Future<List<FoodCategory>> getCategories() async {
    try {
      final response = await DioHelper.getData(
        url: ApiRoutes.foodCategories,
      );

      final body     = response.data as Map<String, dynamic>;
      final dataList = body['data'] as List<dynamic>;
      return FoodCategoryModel.fromJsonList(dataList);
    } catch (e) {
      customPrint('Food categories error ===> $e', isError: true);
      rethrow;
    }
  }

  @override
  Future<List<FoodProviderModel>> compareProducts(FoodCompareRequestModel request) async {
    try {
      final response = await DioHelper.postData(
        url: ApiRoutes.foodCompare,
        data: request.toJson(),
      );
      final body = response.data as Map<String, dynamic>;
      return FoodCompareResponseModel.fromJson(body);
    } catch (e) {
      customPrint('Food compare error ===> $e', isError: true);
      rethrow;
    }
  }
}
