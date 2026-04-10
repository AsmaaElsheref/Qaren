import '../../../../../core/network/handelError/errors/failures.dart';
import '../../../../../core/utils/either.dart';
import '../entities/offer_details_entity.dart';
import '../repositories/car_rental_repository.dart';

class GetOfferDetailsUseCase {
  final CarRentalRepository _repository;

  const GetOfferDetailsUseCase(this._repository);

  Future<Either<Failure, OfferDetailsEntity>> call(String offerId) {
    return _repository.getOfferDetails(offerId);
  }
}

