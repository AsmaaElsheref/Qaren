import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppButton.dart';
import '../pages/searching/searching.dart';
import '../providers/taxi_providers.dart';

class PriceCompareButton extends ConsumerWidget {
  const PriceCompareButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(taxiIsLoadingProvider);
    final canCompare = ref.watch(taxiCanCompareProvider);

    return AppButton(
      label: 'مقارنة الأسعار',
      isLoading: isLoading,
      color: AppColors.primary,
      radius: 15,
      onTap: canCompare && !isLoading
          ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Searching()))
          : null,
    );
  }
}
