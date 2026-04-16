import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/ui/widgets/AppTextField.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../providers/food_providers.dart';

class FoodSearchField extends ConsumerWidget {
  const FoodSearchField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: AppTextField(
        hint: 'ابحث عن طعام أو مطعم...',
        onChanged: (value) {
          ref.read(foodSearchQueryProvider.notifier).state = value;
        },
      ),
    );
  }
}