import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';
import 'package:qaren/features/home/domain/entities/category_entity.dart';
import 'package:qaren/features/home/domain/repositories/home_repository.dart';

class GetCategoriesUseCase {
  final HomeRepository _repository;

  const GetCategoriesUseCase(this._repository);

  Future<Either<Failure, List<CategoryEntity>>> call({
    required String lang,
  }) {
    return _repository.getCategories(lang: lang);
  }
}
