import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/ui/widgets/AppButton.dart';
import '../food_strings.dart';
import '../pages/food_map_picker_page.dart';
import '../providers/food_providers.dart';
import 'food_location_picker_sheet.dart';
import 'foodLoading/food_loading.dart';

/// CTA button at the bottom of the cart page.
///
/// Flow:
///  1. Show [FoodLocationPickerSheet].
///     a. GPS chosen → sheet pops with LatLng → proceed.
///     b. "Map" chosen → sheet pops with null → [FoodMapPickerPage] is already
///        pushed by the sheet; wait for it to pop with LatLng → proceed.
///  2. Navigate to [Searching] and fire compare API.
class ComparePricesButton extends ConsumerWidget {
  const ComparePricesButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEmpty = ref.watch(foodCartIsEmptyProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AppButton(
        label: FoodStrings.comparePrices,
        icon: Icons.directions_bike,
        onTap: isEmpty ? null : () => _onTap(context, ref),
      ),
    );
  }

  Future<void> _onTap(BuildContext context, WidgetRef ref) async {
    // 1. Show location picker sheet.
    //    Returns LatLng when GPS is chosen, or null when map picker is chosen
    //    (the sheet dismisses itself before pushing the map page).
    LatLng? location = await showModalBottomSheet<LatLng>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FoodLocationPickerSheet(),
    );

    if (!context.mounted) return;

    // 2. If sheet returned null the user chose "map" path.
    //    The map page is already on the navigator stack — wait for it.
    if (location == null) {
      location = await Navigator.of(context).push<LatLng>(
        MaterialPageRoute(
          builder: (_) => FoodMapPickerPage(
            initialPosition: ref.read(foodSelectedLocationProvider),
          ),
        ),
      );
      if (location != null) {
        ref.read(foodSelectedLocationProvider.notifier).state = location;
      }
    }

    if (location == null || !context.mounted) return;

    // 3. Navigate to the Searching screen immediately.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Searching()),
    );

    // 4. Fire compare API — Searching screen watches loading state.
    final cartItems = ref.read(foodCartItemsProvider);
    final productIds =
        cartItems.map((item) => int.tryParse(item.id) ?? 0).toList();

    ref.read(foodCompareNotifierProvider.notifier).compare(
          productIds: productIds,
          userLat: location.latitude,
          userLng: location.longitude,
        );
  }
}
