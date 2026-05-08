import 'package:equatable/equatable.dart';

class CarRentalBookingEntity extends Equatable {
  final int? offerId;
  final String customerName;
  final String customerPhone;

  const CarRentalBookingEntity({
    required this.offerId,
    required this.customerName,
    required this.customerPhone,
  });

  @override
  List<Object?> get props => [offerId, customerName, customerPhone];
}

