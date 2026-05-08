import 'package:qaren/core/network/dioHelper/dio_helper.dart';

import '../../domain/entities/booking_service_type.dart';
import '../../domain/entities/booking_status_filter.dart';
import '../models/booking_details_model.dart';
import '../models/booking_history_response_model.dart';
import 'booking_history_remote_datasource.dart';

class BookingHistoryRemoteDataSourceImpl implements BookingHistoryRemoteDataSource {
  const BookingHistoryRemoteDataSourceImpl();

  static const String endpoint = '/api/booking-history';

  @override
  Future<BookingHistoryResponseModel> getBookingHistory({
    required int page,
    required BookingServiceType serviceType,
    required BookingStatusFilter status,
  }) async {
    final query = <String, dynamic>{'page': page};
    final serviceQuery = serviceType.queryValue;
    final statusQuery = status.queryValue;

    if (serviceQuery != null) query['service_type'] = serviceQuery;
    if (statusQuery != null) query['status'] = statusQuery;

    final response = await DioHelper.getData(url: endpoint, query: query);
    return BookingHistoryResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  @override
  Future<BookingDetailsModel> getBookingDetails({required int id}) async {
    final response = await DioHelper.getData(url: '$endpoint/$id');
    return BookingDetailsModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}

