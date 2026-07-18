import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/localization/easy_localization.dart';
import 'package:qaren/core/ui/widgets/toast/toast.dart';
import '../../../../../core/ui/widgets/AppButton.dart';
import '../pages/searching/searching.dart';
import '../providers/taxi_providers.dart';

class PriceCompareButton extends ConsumerWidget {
  const PriceCompareButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(taxiIsLoadingProvider);
    final canCompare = ref.watch(taxiCanCompareProvider);
    final sameLocation = ref.watch(taxiSameLocationProvider);

    return AppButton(
      label: 'taxi.compare.title'.tr(),
      isLoading: isLoading,
      radius: 15,
      onTap: canCompare && !isLoading
          ? () {
              if (sameLocation) {
                toast(
                  context: context,
                  msg: 'taxi.errors.samePickupDestination'.tr(),
                  isError: true,
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Searching()),
              );
            }
          : null,
    );
  }
}
