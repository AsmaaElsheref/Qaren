import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/user_profile_provider.dart';
import '../../../bookings/presentation/providers/booking_history_provider.dart';
import '../../../services/food/presentation/providers/food_data_providers.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';
import 'categories_providers.dart';

final navigationDataRefresherProvider = Provider<NavigationDataRefresher>(
  NavigationDataRefresher.new,
);

class NavigationDataRefresher {
  const NavigationDataRefresher(this._ref);

  final Ref _ref;

  void refreshAfterLocaleChange(int currentIndex) {
    _ref.invalidate(foodCategoriesProvider);
    _ref.invalidate(foodItemsProvider);
    refresh(currentIndex);
  }

  void refresh(int index) {
    switch (index) {
      case 0:
        _ref.invalidate(categoriesNotifierProvider);
      case 1:
        _ref.invalidate(bookingHistoryProvider);
      case 2:
        _ref.invalidate(walletProvider);
      case 3:
        _ref.invalidate(userProfileProvider);
    }
  }
}
