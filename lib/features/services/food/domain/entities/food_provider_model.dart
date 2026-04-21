import 'package:equatable/equatable.dart';
import 'food_product_preview.dart';

/// Immutable model representing a food delivery provider
/// used in price comparison results.
class FoodProviderModel extends Equatable {
  final String id;
  final String name;
  final String? logoUrl;
  final bool isVerified;
  final double? rating;
  final String? ratingCount;
  final double? distanceKm;
  final double? deliveryFee;
  final String currency;
  final double price;
  final int matchedCount;
  final int totalRequested;
  final List<FoodProductPreview> productsPreview;

  /// Smart-pick flags — true when this partner was selected in the given category.
  final bool isBestValue;
  final bool isCheapest;
  final bool isFastest;

  /// Legacy display tag shown under the provider name.
  final String tag;

  const FoodProviderModel({
    required this.id,
    required this.name,
    this.logoUrl,
    this.isVerified = false,
    this.rating,
    this.ratingCount,
    this.distanceKm,
    this.deliveryFee,
    this.currency = 'SAR',
    required this.price,
    this.matchedCount = 0,
    this.totalRequested = 0,
    this.productsPreview = const [],
    this.isBestValue = false,
    this.isCheapest = false,
    this.isFastest = false,
    this.tag = '',
  });

  /// Estimated delivery minutes derived from the min prep-time of previewed products.
  int get deliveryTimeMinutes {
    if (productsPreview.isEmpty) return 0;
    return productsPreview
        .where((p) => p.prepTimeMin != null)
        .fold<int>(999, (min, p) => p.prepTimeMin! < min ? p.prepTimeMin! : min)
        .clamp(0, 999);
  }

  @override
  List<Object?> get props => [id];
}