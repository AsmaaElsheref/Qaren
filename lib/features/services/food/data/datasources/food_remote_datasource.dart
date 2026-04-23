import '../../../../../core/network/apiRoutes/api_routes.dart';
import '../../../../../core/network/dioHelper/dio_helper.dart';
import '../../../../../core/utils/print/custom_print.dart';
import '../../domain/entities/food_category.dart';
import '../../domain/entities/food_invoice_detail.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/food_provider_model.dart';
import '../models/food_category_model.dart';
import '../models/food_compare_request_model.dart';
import '../models/food_compare_response_model.dart';
import '../models/food_invoice_detail_model.dart';
import '../models/food_product_model.dart';

/// Remote data source for the food delivery feature.
abstract class FoodRemoteDataSource {
  Future<List<FoodItem>> getProducts({String? search, String? categoryId});
  Future<List<FoodCategory>> getCategories();
  Future<List<FoodProviderModel>> compareProducts(FoodCompareRequestModel request);

  /// Fetches full invoice detail for a single partner.
  /// [partnerId]  — the partner to fetch
  /// [productIds] — the cart product ids
  /// [userLat]    — user latitude
  /// [userLng]    — user longitude
  Future<FoodInvoiceDetail> getInvoiceDetail({
    required int partnerId,
    required List<int> productIds,
    required double userLat,
    required double userLng,
  });
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

  @override
  Future<FoodInvoiceDetail> getInvoiceDetail({
    required int partnerId,
    required List<int> productIds,
    required double userLat,
    required double userLng,
  }) async {
    try {
      // Build query: product_ids[]=1&product_ids[]=2&...
      final query = <String, dynamic>{
        'product_ids[]': productIds,
        'user_lat': userLat,
        'user_lng': userLng,
      };

      final response = await DioHelper.getData(
        url: ApiRoutes.foodInvoiceDetail(partnerId),
        query: query,
      );

      final body = response.data as Map<String, dynamic>;
      return FoodInvoiceDetailModel.fromJson(body);
    } catch (e) {
      customPrint('Food invoice detail error ===> $e', isError: true);
      rethrow;
    }
  }
}
