import 'package:equatable/equatable.dart';

/// Represents a single product inside the invoice detail response.
class InvoiceProduct extends Equatable {
  const InvoiceProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.thumbnail,
    this.calories,
    this.prepTimeMin,
    this.rating,
  });

  final int id;
  final String name;
  final double price;
  final String thumbnail;
  final String? calories;
  final String? prepTimeMin;
  final String? rating;

  @override
  List<Object?> get props => [id];
}

