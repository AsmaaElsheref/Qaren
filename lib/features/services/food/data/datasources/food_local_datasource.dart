import '../../domain/entities/restaurant.dart';

/// Local dummy data source for the food feature.
/// Will be replaced by a remote data source when API is ready.
abstract class FoodLocalDataSource {
  Restaurant getRestaurant(String categoryId);
}

class FoodLocalDataSourceImpl implements FoodLocalDataSource {
  const FoodLocalDataSourceImpl();

  @override
  Restaurant getRestaurant(String categoryId) {
    return const Restaurant(
      id: 'r1',
      name: 'food.mockRestaurant.name',
      rating: 4.5,
      deliveryTime: 'food.mockRestaurant.deliveryTime',
      menuCount: 79,
      category: 'food.mockRestaurant.category',
      imageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200',
    );
  }
}
