import '../../domain/entities/food_invoice_model.dart';

/// Dummy data kept for invoice screen fallback.
/// Product comparison is now driven by the remote API.
class FoodComparisonLocalData {
  FoodComparisonLocalData._();

  static const FoodInvoiceModel sampleInvoice = FoodInvoiceModel(
    fromLocation: 'مطعم وجبة',
    toLocation: 'المنزل',
    distance: '4 كم',
    deliveryTimeMinutes: 50,
    itemsCount: 1,
    orderTime: 'الآن',
    date: 'الآن',
  );
}
