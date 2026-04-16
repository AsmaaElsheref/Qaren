import 'package:equatable/equatable.dart';

import 'food_provider_model.dart';

/// Immutable model for the order invoice / receipt screen.
class FoodInvoiceModel extends Equatable {
  final FoodProviderModel provider;
  final String fromLocation;
  final String toLocation;
  final String distance;
  final int deliveryTimeMinutes;
  final int itemsCount;
  final String orderTime;
  final String date;

  const FoodInvoiceModel({
    required this.provider,
    required this.fromLocation,
    required this.toLocation,
    required this.distance,
    required this.deliveryTimeMinutes,
    required this.itemsCount,
    required this.orderTime,
    required this.date,
  });

  @override
  List<Object?> get props => [provider, fromLocation, toLocation];
}

