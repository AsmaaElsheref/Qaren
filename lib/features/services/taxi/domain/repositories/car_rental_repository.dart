import '../../../../../core/network/handelError/errors/failures.dart';
import '../../../../../core/utils/either.dart';
import '../entities/car_rental_search_params.dart';
import '../entities/car_rental_search_result_entity.dart';

abstract class CarRentalRepository {
  Future<Either<Failure, CarRentalSearchResultEntity>> searchOffers(
    CarRentalSearchParams params,
  );
}

