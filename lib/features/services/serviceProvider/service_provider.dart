import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/features/services/taxi/presentation/pages/taxi_page.dart';

/// Maps each [ServiceCategory.id] to its corresponding page widget.
/// Add a new entry here whenever you add a new service — no conditions needed.
final serviceRoutesProvider = Provider<Map<String, Widget>>((ref) {
  return const {
    'taxi': TaxiPage(),
    // 'food': FoodPage(),
    // 'flights': FlightsPage(),
    // ... add more as you build them
  };
});

