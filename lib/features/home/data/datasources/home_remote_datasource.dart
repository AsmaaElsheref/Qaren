import 'package:qaren/core/network/dioHelper/dio_helper.dart';
import 'package:qaren/core/network/apiRoutes/api_routes.dart';
import 'package:qaren/features/home/data/models/category_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl();

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await DioHelper.getData(url: ApiRoutes.categories);

    final body = response.data as Map<String, dynamic>;
    final dataList = body['data'] as List<dynamic>;

    return dataList
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
