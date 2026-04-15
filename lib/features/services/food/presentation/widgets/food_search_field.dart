import 'package:flutter/material.dart';
import 'package:qaren/core/ui/widgets/AppTextField.dart';
import '../../../../../core/constants/app_dimensions.dart';

class FoodSearchField extends StatelessWidget {
  const FoodSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: AppTextField(
        hint: 'ابحث عن طعام أو مطعم...',
      ),
    );
  }
}

