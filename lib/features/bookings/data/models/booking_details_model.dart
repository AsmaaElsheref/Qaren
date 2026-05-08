import '../../domain/entities/booking_details_entity.dart';
import 'booking_model.dart';

class BookingDetailsModel extends BookingDetailsEntity {
  const BookingDetailsModel({required super.booking});

  factory BookingDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final bookingJson = data is Map<String, dynamic>
        ? data
        : Map<String, dynamic>.from(data as Map? ?? json);

    return BookingDetailsModel(
      booking: BookingModel.fromJson(bookingJson),
    );
  }
}

