import 'package:equatable/equatable.dart';

/// Metadata about a car rental provider (rating, badges, etc.).
class ProviderDataEntity extends Equatable {
  final double? rating;
  final bool isInstantBook;
  final bool freeCancellation;

  const ProviderDataEntity({
    this.rating,
    this.isInstantBook = false,
    this.freeCancellation = false,
  });

  @override
  List<Object?> get props => [rating, isInstantBook, freeCancellation];
}

