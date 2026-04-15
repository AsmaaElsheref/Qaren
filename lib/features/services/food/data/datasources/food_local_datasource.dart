import '../../domain/entities/food_category.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/entities/restaurant.dart';

/// Local dummy data source for the food feature.
/// Will be replaced by a remote data source when API is ready.
abstract class FoodLocalDataSource {
  List<FoodCategory> getCategories();
  Restaurant getRestaurant(String categoryId);
  List<FoodItem> getFoodItems(String categoryId);
}

class FoodLocalDataSourceImpl implements FoodLocalDataSource {
  const FoodLocalDataSourceImpl();

  @override
  List<FoodCategory> getCategories() {
    return const [
      FoodCategory(id: 'all', name: 'الكل'),
      FoodCategory(id: 'burger', name: 'برجر'),
      FoodCategory(id: 'pizza', name: 'بيتزا'),
      FoodCategory(id: 'healthy', name: 'صحي'),
      FoodCategory(id: 'asian', name: 'آسيوي'),
    ];
  }

  @override
  Restaurant getRestaurant(String categoryId) {
    return const Restaurant(
      id: 'r1',
      name: 'برجر كنج',
      rating: 4.5,
      deliveryTime: '٢٠-٣٠ د',
      menuCount: 79,
      category: 'برجر',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200',
    );
  }

  @override
  List<FoodItem> getFoodItems(String categoryId) {
    return const [
      FoodItem(
        id: 'f1',
        name: 'وجبة ووبر',
        description: 'برجر مشوي بطاطس، مشروب',
        price: 25,
        calories: 950,
        rating: 4.8,
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200',
        restaurantId: 'r1',
      ),
      FoodItem(
        id: 'f2',
        name: 'دبل تشيز برجر',
        description: 'شريحتين لحم مع جبنة',
        price: 22,
        calories: 720,
        rating: 4.6,
        imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=200',
        restaurantId: 'r1',
      ),
      FoodItem(
        id: 'f3',
        name: 'بطاطس ودجز',
        description: 'مقرمشة ولذيذة',
        price: 12,
        calories: 340,
        rating: 4.5,
        imageUrl: 'https://images.unsplash.com/photo-1630384060421-cb20d0e0649d?w=200',
        restaurantId: 'r1',
      ),
    ];
  }
}

