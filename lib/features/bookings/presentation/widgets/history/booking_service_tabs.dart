import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';

import '../../../domain/entities/booking_service_type.dart';
import '../../providers/booking_history_provider.dart';

class BookingServiceTabs extends ConsumerWidget {
  const BookingServiceTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(
      bookingHistoryProvider.select((state) => state.selectedServiceType),
    );

    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = BookingServiceType.values[index];
          if (item == BookingServiceType.unknown) return const SizedBox.shrink();
          final isSelected = item == selected;
          return ChoiceChip(
            selected: isSelected,
            label: AppText(item.label),
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            onSelected: (_) => ref
                .read(bookingHistoryProvider.notifier)
                .changeServiceType(item),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.paddingS),
        itemCount: BookingServiceType.values.length - 1,
      ),
    );
  }
}

