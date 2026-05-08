import '../../domain/entities/booking_service_type.dart';
import '../../domain/entities/booking_status_filter.dart';
import '../models/booking_details_model.dart';
import '../models/booking_history_response_model.dart';

abstract class BookingHistoryRemoteDataSource {
  Future<BookingHistoryResponseModel> getBookingHistory({
    required int page,
    required BookingServiceType serviceType,
    required BookingStatusFilter status,
  });

  Future<BookingDetailsModel> getBookingDetails({required int id});
}

