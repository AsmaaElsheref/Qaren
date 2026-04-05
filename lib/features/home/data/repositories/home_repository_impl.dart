import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';
import 'package:qaren/features/home/domain/entities/category_entity.dart';
import 'package:qaren/features/home/domain/repositories/home_repository.dart';
import 'package:qaren/features/home/data/datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  const HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories({
    required String lang,
  }) async {
    try {
      final categories = await _remoteDataSource.getCategories(lang: lang);
      return Either.rightOf(categories);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (e) {
      return Either.leftOf(ServerFailure(e.toString()));
    }
  }
}
