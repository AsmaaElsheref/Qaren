import '../../../../../core/network/handelError/errors/failures.dart';
import '../../../../../core/utils/either.dart';
import '../entities/car_rental_search_params.dart';
import '../entities/car_rental_search_result_entity.dart';
import '../repositories/car_rental_repository.dart';

class SearchCarRentalUseCase {
  final CarRentalRepository _repository;

  const SearchCarRentalUseCase(this._repository);

  Future<Either<Failure, CarRentalSearchResultEntity>> call(
    CarRentalSearchParams params,
  ) {
    return _repository.searchOffers(params);
  }
}

