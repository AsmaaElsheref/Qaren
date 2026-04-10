import '../../../../../core/network/handelError/errors/failures.dart';
import '../../../../../core/utils/either.dart';
import '../entities/book_car_rental_params.dart';
import '../entities/booking_result_entity.dart';
import '../entities/car_rental_search_params.dart';
import '../entities/car_rental_search_result_entity.dart';
import '../entities/offer_details_entity.dart';

abstract class CarRentalRepository {
  Future<Either<Failure, CarRentalSearchResultEntity>> searchOffers(
    CarRentalSearchParams params,
  );

  Future<Either<Failure, OfferDetailsEntity>> getOfferDetails(
    String offerId,
  );

  Future<Either<Failure, BookingResultEntity>> bookOffer(
    BookCarRentalParams params,
  );
}

