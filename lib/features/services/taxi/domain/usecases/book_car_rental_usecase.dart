import '../../../../../core/network/handelError/errors/failures.dart';
import '../../../../../core/utils/either.dart';
import '../entities/book_car_rental_params.dart';
import '../entities/booking_result_entity.dart';
import '../repositories/car_rental_repository.dart';

class BookCarRentalUseCase {
  final CarRentalRepository _repository;

  const BookCarRentalUseCase(this._repository);

  Future<Either<Failure, BookingResultEntity>> call(
    BookCarRentalParams params,
  ) {
    return _repository.bookOffer(params);
  }
}