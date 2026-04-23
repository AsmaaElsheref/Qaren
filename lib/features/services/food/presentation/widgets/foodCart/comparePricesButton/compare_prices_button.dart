import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../../../core/ui/widgets/AppButton.dart';
import '../../../../domain/entities/food_location_result.dart';
import '../../../food_strings.dart';
import '../../../providers/food_comparison_provider.dart';
import '../../../providers/food_providers.dart';
import '../../comparison/foodLoading/food_loading.dart';
import '../foodLocationPickerSheet/food_location_picker_sheet.dart';
import '../foodmapPickerPage/food_map_picker_page.dart';

/// CTA button at the bottom of the cart page.
///
/// Flow:
///  1. Show [FoodLocationPickerSheet].
///     a. GPS chosen → sheet pops with LatLng → proceed (name = "موقعي الحالي").
///     b. "Map" chosen → sheet pops with null → push [FoodMapPickerPage] which
///        pops with [FoodLocationResult] (LatLng + resolved address name).
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
    LatLng? location;
    String locationName = '';

    // 1. Show location picker sheet.
    //    GPS path → pops with LatLng.
    //    Map path → pops with null (sheet dismisses itself first).
    final gpsResult = await showModalBottomSheet<LatLng>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FoodLocationPickerSheet(),
    );

    if (!context.mounted) return;

    if (gpsResult != null) {
      // GPS path — use a friendly label instead of coordinates.
      location = gpsResult;
      locationName = 'موقعي الحالي';
    } else {
      // Map path — FoodMapPickerPage pops with FoodLocationResult.
      final mapResult = await Navigator.of(context).push<FoodLocationResult>(
        MaterialPageRoute(
          builder: (_) => FoodMapPickerPage(
            initialPosition: ref.read(foodSelectedLocationProvider),
          ),
        ),
      );
      if (mapResult != null) {
        location = mapResult.latLng;
        locationName = mapResult.name;
      }
    }

    if (location == null || !context.mounted) return;

    // 2. Persist both location and its name.
    ref.read(foodSelectedLocationProvider.notifier).state = location;
    ref.read(foodSelectedLocationNameProvider.notifier).state = locationName;

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
