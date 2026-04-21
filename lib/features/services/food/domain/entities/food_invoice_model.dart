import 'package:equatable/equatable.dart';

import 'food_provider_model.dart';

/// Immutable model for the order invoice / receipt screen.
// ignore_for_file: unused_element
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
    FoodProviderModel? provider,
    this.fromLocation = '',
    this.toLocation = '',
    this.distance = '',
    this.deliveryTimeMinutes = 0,
    this.itemsCount = 0,
    this.orderTime = '',
    this.date = '',
  }) : provider = provider ?? const FoodProviderModel(id: '', name: '', price: 0);

  @override
  List<Object?> get props => [provider, fromLocation, toLocation];
}

