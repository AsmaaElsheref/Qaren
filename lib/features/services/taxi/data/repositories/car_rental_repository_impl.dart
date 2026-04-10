import '../../../../../core/network/handelError/errors/failures.dart';
import '../../../../../core/utils/either.dart';
import '../../domain/entities/book_car_rental_params.dart';
import '../../domain/entities/booking_result_entity.dart';
import '../../domain/entities/car_rental_search_params.dart';
import '../../domain/entities/car_rental_search_result_entity.dart';
import '../../domain/entities/offer_details_entity.dart';
import '../../domain/repositories/car_rental_repository.dart';
import '../datasources/car_rental_remote_datasource.dart';

class CarRentalRepositoryImpl implements CarRentalRepository {
  final CarRentalRemoteDataSource _remoteDataSource;

  const CarRentalRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, CarRentalSearchResultEntity>> searchOffers(
    CarRentalSearchParams params,
  ) async {
    try {
      final result = await _remoteDataSource.searchOffers(params);
      return Either.rightOf(result);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(
        const ServerFailure('فشل البحث عن العروض. حاول مرة أخرى.'),
      );
    }
  }

  @override
  Future<Either<Failure, OfferDetailsEntity>> getOfferDetails(
    String offerId,
  ) async {
    try {
      final result = await _remoteDataSource.getOfferDetails(offerId);
      return Either.rightOf(result);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(
        const ServerFailure('فشل تحميل تفاصيل العرض. حاول مرة أخرى.'),
      );
    }
  }

  @override
  Future<Either<Failure, BookingResultEntity>> bookOffer(
    BookCarRentalParams params,
  ) async {
    try {
      final result = await _remoteDataSource.bookOffer(params);
      return Either.rightOf(result);
    } on Failure catch (f) {
      return Either.leftOf(f);
    } catch (_) {
      return Either.leftOf(
        const ServerFailure('فشل الحجز. حاول مرة أخرى.'),
      );
    }
  }
}

