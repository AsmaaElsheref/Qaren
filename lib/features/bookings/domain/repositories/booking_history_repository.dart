import 'package:qaren/core/network/handelError/errors/failures.dart';
import 'package:qaren/core/utils/either.dart';

import '../entities/booking_details_entity.dart';
import '../entities/booking_pagination_entity.dart';
import '../entities/booking_service_type.dart';
import '../entities/booking_status_filter.dart';

abstract class BookingHistoryRepository {
  Future<Either<Failure, BookingPaginationEntity>> getBookingHistory({
    required int page,
    required BookingServiceType serviceType,
    required BookingStatusFilter status,
  });

  Future<Either<Failure, BookingDetailsEntity>> getBookingDetails({
    required int id,
  });
}

