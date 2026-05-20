import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';

import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../../../../../core/ui/widgets/AppTextField.dart';
import '../../food_strings.dart';
import '../../providers/food_providers.dart';

class CheckoutNotesInput extends ConsumerStatefulWidget {
  const CheckoutNotesInput({super.key});

  @override
  ConsumerState<CheckoutNotesInput> createState() =>
      CheckoutNotesInputState();
}

class CheckoutNotesInputState extends ConsumerState<CheckoutNotesInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(checkoutNotesProvider),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'ملاحظات',
            style: TextStyle(
              fontSize: AppDimensions.fontM,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          AppTextField(
            controller: _controller,
            hint: FoodStrings.notesHint,
            maxLines: 3,
            minLines: 2,
            onChanged: (v) => ref.read(checkoutNotesProvider.notifier).state = v,
          ),
        ],
      ),
    );
  }
}

