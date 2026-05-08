import '../../domain/entities/booking_pagination_entity.dart';
import 'booking_model.dart';

class BookingPaginationModel extends BookingPaginationEntity {
  const BookingPaginationModel({
    required super.currentPage,
    required super.bookings,
    required super.nextPageUrl,
    required super.perPage,
    required super.total,
  });

  factory BookingPaginationModel.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? const [];

    return BookingPaginationModel(
      currentPage: BookingModel.parseInt(json['current_page']) ?? 1,
      bookings: list
          .whereType<Map>()
          .map((item) => BookingModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false),
      nextPageUrl: json['next_page_url'] as String?,
      perPage: BookingModel.parseInt(json['per_page']) ?? 15,
      total: BookingModel.parseInt(json['total']) ?? 0,
    );
  }
}

