import 'package:equatable/equatable.dart';

class FoodOrderBookingEntity extends Equatable {
  final int? bookingId;
  final int? partnerId;
  final String deliveryType;
  final String deliveryAddress;
  final int? itemsCount;
  final String customerNotes;
  final String paymentMethod;
  final String paymentStatus;

  const FoodOrderBookingEntity({
    required this.bookingId,
    required this.partnerId,
    required this.deliveryType,
    required this.deliveryAddress,
    required this.itemsCount,
    required this.customerNotes,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  @override
  List<Object?> get props => [
        bookingId,
        partnerId,
        deliveryType,
        deliveryAddress,
        itemsCount,
        customerNotes,
        paymentMethod,
        paymentStatus,
      ];
}

