import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/localization/easy_localization.dart';
import 'package:qaren/core/utils/either.dart';
import 'package:qaren/features/home/domain/entities/category_entity.dart';
import 'package:qaren/features/home/domain/repositories/home_repository.dart';
import 'package:qaren/features/home/data/datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  const HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await _remoteDataSource.getCategories();
      return Either.rightOf(categories);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(ServerFailure('errors.unexpected'.tr()));
    }
  }
}
