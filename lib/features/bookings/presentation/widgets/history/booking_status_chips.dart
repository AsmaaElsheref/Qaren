import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';

import '../../../domain/entities/booking_status_filter.dart';
import '../../providers/booking_history_provider.dart';

class BookingStatusChips extends ConsumerWidget {
  const BookingStatusChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(
      bookingHistoryProvider.select((state) => state.selectedStatus),
    );

    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = BookingStatusFilter.values[index];
          final isSelected = item == selected;
          return ChoiceChip(
            selected: isSelected,
            label: AppText(item.label),
            selectedColor: AppColors.primaryLight,
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            onSelected: (_) => ref
                .read(bookingHistoryProvider.notifier)
                .changeStatus(item),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: AppDimensions.paddingS),
        itemCount: BookingStatusFilter.values.length,
      ),
    );
  }
}

