import 'package:equatable/equatable.dart';

/// Immutable entity representing one warehouse/branch of a food product.
///
/// Maps the `warehouses[]` array returned by
/// GET /api/compare/food-delivery/products. The booking API requires
/// [foodProductWarehouseId] for every ordered item.
class FoodWarehouse extends Equatable {
  final int foodProductWarehouseId;
  final int warehouseId;
  final String name;
  final String city;
  final String area;
  final String address;
  final bool isActive;
  final double? latitude;
  final double? longitude;

  const FoodWarehouse({
    required this.foodProductWarehouseId,
    required this.warehouseId,
    required this.name,
    this.city = '',
    this.area = '',
    this.address = '',
    this.isActive = true,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [foodProductWarehouseId];
}

