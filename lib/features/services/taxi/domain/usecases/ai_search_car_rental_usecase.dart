import '../../../../../core/network/handelError/errors/failures.dart';
import '../../../../../core/utils/either.dart';
import '../entities/ai_search_params.dart';
import '../entities/car_rental_search_result_entity.dart';
import '../repositories/car_rental_repository.dart';

/// Performs a natural-language car-rental search via the AI assistant endpoint.
class AiSearchCarRentalUseCase {
  final CarRentalRepository _repository;

  const AiSearchCarRentalUseCase(this._repository);

  Future<Either<Failure, CarRentalSearchResultEntity>> call(
    AiSearchParams params,
  ) {
    return _repository.aiSearchOffers(params);
  }
}

