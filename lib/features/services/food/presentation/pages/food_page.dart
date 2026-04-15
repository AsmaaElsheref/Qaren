import 'package:flutter/material.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../food_strings.dart';
import '../widgets/food_app_header.dart';
import '../widgets/food_category_chips.dart';
import '../widgets/food_restaurant_card.dart';
import '../widgets/food_search_field.dart';
import '../widgets/food_section_title.dart';

/// Food delivery screen.
///
/// This page only composes widgets — zero business logic, zero state management.
/// Each section is an independent widget with its own rebuild scope.
class FoodPage extends StatelessWidget {
  const FoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
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
      ),
    );
  }
}
