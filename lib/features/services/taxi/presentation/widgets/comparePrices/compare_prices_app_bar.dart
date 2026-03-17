import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/ui/widgets/icon_container.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/ui/widgets/AppText.dart';
import '../../providers/taxi_notifier.dart';
import 'breadcrumb.dart';

class ComparePricesAppBar extends ConsumerWidget {
  const ComparePricesAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickup = ref.watch(taxiProvider.select((s) => s.pickup));
    final destination = ref.watch(taxiProvider.select((s) => s.destination));
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        child: Row(
          children: [
            IconContainer(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(width: AppDimensions.paddingS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppText(
                    'مقارنة الأسعار',
                    style: TextStyle(
                      fontSize: AppDimensions.fontL,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Breadcrumb(pickup: pickup, destination: destination),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}