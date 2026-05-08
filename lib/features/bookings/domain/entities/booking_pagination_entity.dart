import 'package:equatable/equatable.dart';

import 'booking_entity.dart';

class BookingPaginationEntity extends Equatable {
  final int currentPage;
  final List<BookingEntity> bookings;
  final String? nextPageUrl;
  final int perPage;
  final int total;

  const BookingPaginationEntity({
    required this.currentPage,
    required this.bookings,
    required this.nextPageUrl,
    required this.perPage,
    required this.total,
  });

  bool get hasMore => nextPageUrl != null && nextPageUrl!.isNotEmpty;

  @override
  List<Object?> get props => [currentPage, bookings, nextPageUrl, perPage, total];
}

