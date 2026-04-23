import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../food_strings.dart';
import '../../providers/food_providers.dart';
import '../../widgets/food/food_app_header.dart';
import '../../widgets/food/food_category_chips.dart';
import '../../widgets/food/food_search_field.dart';
import '../../widgets/food/food_restaurant_card.dart';
import '../../widgets/food/food_section_title.dart';

/// Food delivery screen.
///
/// Purely compositional — zero business logic inside the build tree.
/// Converted to [ConsumerStatefulWidget] solely to reset state on dispose:
/// when the user navigates back, [selectedFoodCategoryProvider] and
/// [foodSearchQueryProvider] are both restored to their defaults so the
/// next visit always starts fresh.
class FoodPage extends ConsumerStatefulWidget {
  const FoodPage({super.key});

  @override
  ConsumerState<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends ConsumerState<FoodPage> {
  /// Resets filter/search state when the user leaves the screen.
  /// Called by the framework before the widget is removed from the tree,
  /// so [ref] is still valid here (before super.dispose()).
  @override
  void dispose() {
    ref.read(selectedFoodCategoryProvider.notifier).state = 'all';
    ref.read(foodSearchQueryProvider.notifier).state = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                SizedBox(height: AppDimensions.paddingS),
                FoodAppHeader(),
                SizedBox(height: AppDimensions.paddingM),
                FoodSearchField(),
                SizedBox(height: AppDimensions.paddingM),
                FoodCategoryChips(),
                SizedBox(height: AppDimensions.paddingM),
                FoodSectionTitle(title: FoodStrings.mostOrdered),
                SizedBox(height: AppDimensions.paddingS),
                FoodRestaurantCard(),
                SizedBox(height: AppDimensions.paddingXL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
