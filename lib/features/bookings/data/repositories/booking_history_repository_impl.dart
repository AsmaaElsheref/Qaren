import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';

import '../../domain/entities/booking_details_entity.dart';
import '../../domain/entities/booking_pagination_entity.dart';
import '../../domain/entities/booking_service_type.dart';
import '../../domain/entities/booking_status_filter.dart';
import '../../domain/repositories/booking_history_repository.dart';
import '../datasources/booking_history_remote_datasource.dart';

class BookingHistoryRepositoryImpl implements BookingHistoryRepository {
  final BookingHistoryRemoteDataSource remoteDataSource;

  const BookingHistoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, BookingPaginationEntity>> getBookingHistory({
    required int page,
    required BookingServiceType serviceType,
    required BookingStatusFilter status,
  }) async {
    try {
      final response = await remoteDataSource.getBookingHistory(
        page: page,
        serviceType: serviceType,
        status: status,
      );
      return Either.rightOf(response.pagination);
    } on Failure catch (failure) {
      return Either.leftOf(failure);
    } catch (error) {
      return Either.leftOf(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingDetailsEntity>> getBookingDetails({
    required int id,
  }) async {
    try {
      final details = await remoteDataSource.getBookingDetails(id: id);
      return Either.rightOf(details);
    } on Failure catch (failure) {
      return Either.leftOf(failure);
    } catch (error) {
      return Either.leftOf(ServerFailure(error.toString()));
    }
  }
}

