import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';

import '../entities/booking_pagination_entity.dart';
import '../entities/booking_service_type.dart';
import '../entities/booking_status_filter.dart';
import '../repositories/booking_history_repository.dart';

class GetBookingHistoryUseCase {
  final BookingHistoryRepository repository;

  const GetBookingHistoryUseCase(this.repository);

  Future<Either<Failure, BookingPaginationEntity>> call({
    required int page,
    required BookingServiceType serviceType,
    required BookingStatusFilter status,
  }) {
    return repository.getBookingHistory(
      page: page,
      serviceType: serviceType,
      status: status,
    );
  }
}
