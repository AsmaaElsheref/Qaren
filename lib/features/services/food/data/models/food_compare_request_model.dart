/// Request body for POST /api/food-products/compare
class FoodCompareRequestModel {
  final List<int> productIds;
  final double userLat;
  final double userLng;

  const FoodCompareRequestModel({
    required this.productIds,
    required this.userLat,
    required this.userLng,
  });

  Map<String, dynamic> toJson() => {
        'product_ids': productIds,
        'user_lat': userLat,
        'user_lng': userLng,
      };
}

