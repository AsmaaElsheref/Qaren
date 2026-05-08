import 'booking_pagination_model.dart';

class BookingHistoryResponseModel {
  final bool status;
  final BookingPaginationModel pagination;

  const BookingHistoryResponseModel({
    required this.status,
    required this.pagination,
  });

  factory BookingHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return BookingHistoryResponseModel(
      status: json['status'] as bool? ?? false,
      pagination: BookingPaginationModel.fromJson(
        data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data as Map? ?? {}),
      ),
    );
  }
}

