import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/ui/widgets/AppTextField.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../providers/food_providers.dart';

/// Search field for the food delivery screen.
///
/// Debounces the user's input by 500 ms before committing it to
/// [foodSearchQueryProvider], which triggers a server-side search API call.
///
/// Listens to [foodSearchQueryProvider] so that when [FoodPage] resets the
/// provider to '' on dispose, the visible text inside the field is also
/// cleared — keeping the controller in sync with the provider at all times.
class FoodSearchField extends ConsumerStatefulWidget {
  const FoodSearchField({super.key});

  @override
  ConsumerState<FoodSearchField> createState() => _FoodSearchFieldState();
}

class _FoodSearchFieldState extends ConsumerState<FoodSearchField> {
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      ref.read(foodSearchQueryProvider.notifier).state = value.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    // When the provider is externally reset to '' (e.g. FoodPage.dispose()),
    // clear the visible text so the field reflects the reset state.
    ref.listen<String>(foodSearchQueryProvider, (previous, next) {
      if (next.isEmpty && _controller.text.isNotEmpty) {
        _debounceTimer?.cancel();
        _controller.clear();
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: AppTextField(
        controller: _controller,
        hint: 'ابحث عن طعام أو مطعم...',
        onChanged: _onChanged,
      ),
    );
  }
}