import 'package:equatable/equatable.dart';

class BookingPricingEntity extends Equatable {
  final double? totalPrice;
  final double? subtotal;
  final double? deliveryFee;
  final String currency;
  final bool available;

  const BookingPricingEntity({
    required this.totalPrice,
    required this.subtotal,
    required this.deliveryFee,
    required this.currency,
    required this.available,
  });

  bool get canShowTotal => available && totalPrice != null;

  @override
  List<Object?> get props => [totalPrice, subtotal, deliveryFee, currency, available];
}

