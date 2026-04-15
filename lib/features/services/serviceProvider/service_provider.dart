import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/features/services/taxi/presentation/pages/taxi_page.dart';

import '../food/presentation/pages/food_page.dart';

/// Maps each [CategoryEntity.type] (from the API) to its page widget.
/// Add a new entry whenever you build a new service — keyed by the API `type`.
final serviceRoutesProvider = Provider<Map<String, Widget>>((ref) {
  return const {
    'taxi': TaxiPage(),
    'car_rental': TaxiPage(),
    'food_delivery': FoodPage(),
    // 'flights':        FlightsPage(),
    // 'hotels':         HotelsPage(),
    // 'insurance':      InsurancePage(),
    // 'shopping':       ShoppingPage(),
    // 'home_services':  HomeServicesPage(),
    // 'furniture':      FurniturePage(),
    // 'parcel':         ParcelPage(),
    // 'salon':          SalonPage(),
    // 'events':         EventsPage(),
  };
});



