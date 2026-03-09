import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/ui/widgets/AppButton.dart';
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
      onTap: canCompare && !isLoading
          ? () => ref.read(taxiProvider.notifier).comparePrices()
          : null,
    );
  }
}
