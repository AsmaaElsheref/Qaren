import 'package:equatable/equatable.dart';

import 'booking_entity.dart';

class BookingDetailsEntity extends Equatable {
  final BookingEntity booking;

  const BookingDetailsEntity({required this.booking});

  @override
  List<Object?> get props => [booking];
}

