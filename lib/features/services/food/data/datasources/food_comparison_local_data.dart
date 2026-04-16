import '../../domain/entities/food_invoice_model.dart';
import '../../domain/entities/food_provider_model.dart';

/// Dummy data for food price comparison and invoice screens.
/// Will be replaced by remote data source when API is ready.
class FoodComparisonLocalData {
  FoodComparisonLocalData._();

  static const List<FoodProviderModel> providers = [
    FoodProviderModel(
      id: 'toyou',
      name: 'تويو',
      imageUrl: '',
      price: 5,
      rating: 4.2,
      deliveryTimeMinutes: 50,
      isBestValue: true,
      tag: 'عرض ترويجي',
    ),
    FoodProviderModel(
      id: 'jahez',
      name: 'جاهز',
      imageUrl: '',
      price: 12,
      rating: 4.8,
      deliveryTimeMinutes: 30,
      isBestValue: false,
      tag: 'توصيل سريع',
    ),
    FoodProviderModel(
      id: 'hungerstation',
      name: 'هنقرستيشن',
      imageUrl: '',
      price: 9,
      rating: 4.5,
      deliveryTimeMinutes: 40,
      isBestValue: false,
      tag: 'توصيل موثوق',
    ),
  ];

  static const FoodInvoiceModel sampleInvoice = FoodInvoiceModel(
    provider: FoodProviderModel(
      id: 'toyou',
      name: 'تويو',
      imageUrl: '',
      price: 5,
      rating: 4.2,
      deliveryTimeMinutes: 50,
      isBestValue: true,
      tag: 'عرض ترويجي',
    ),
    fromLocation: 'مطعم وجبة',
    toLocation: 'المنزل',
    distance: '4 كم',
    deliveryTimeMinutes: 50,
    itemsCount: 1,
    orderTime: 'الآن',
    date: 'الآن',
  );
}
