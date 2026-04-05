import 'package:qaren/core/network/dioHelper/dio_helper.dart';
import 'package:qaren/features/home/data/models/category_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<CategoryModel>> getCategories({required String lang});
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl();

  // endpoint: /api/categories  (see ApiRoutes.categories)
  static const String _endpoint = '/api/categories';

  @override
  Future<List<CategoryModel>> getCategories({required String lang}) async {
    final response = await DioHelper.getData(
      url: _endpoint,
      query: <String, dynamic>{'lang': lang},
    );

    final body     = response.data as Map<String, dynamic>;
    final dataList = body['data']  as List<dynamic>;

    return dataList
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
