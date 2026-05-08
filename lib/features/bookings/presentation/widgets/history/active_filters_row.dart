import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import '../../../domain/entities/booking_service_type.dart';
import '../../../domain/entities/booking_status_filter.dart';
import '../../providers/booking_history_provider.dart';
import 'booking_filter_sheet.dart';

/// Shows the currently active filters as removable chips.
/// Renders nothing when both filters are at their default "all" values.
class ActiveFiltersRow extends ConsumerWidget {
  const ActiveFiltersRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serviceType = ref.watch(
      bookingHistoryProvider.select((s) => s.selectedServiceType),
    );
    final status = ref.watch(
      bookingHistoryProvider.select((s) => s.selectedStatus),
    );

    final hasServiceFilter = serviceType != BookingServiceType.all;
    final hasStatusFilter = status != BookingStatusFilter.all;

    if (!hasServiceFilter && !hasStatusFilter) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: Row(
        children: [
          const AppText('الفلاتر:', style: AppTextStyles.caption),
          const SizedBox(width: AppDimensions.paddingS),
          Expanded(
            child: Wrap(
              spacing: AppDimensions.paddingS,
              runSpacing: AppDimensions.paddingXS,
              children: [
                if (hasServiceFilter)
                  ActiveFilterChip(
                    label: serviceType.label,
                    onRemove: () => ref
                        .read(bookingHistoryProvider.notifier)
                        .changeServiceType(BookingServiceType.all),
                  ),
                if (hasStatusFilter)
                  ActiveFilterChip(
                    label: status.label,
                    onRemove: () => ref
                        .read(bookingHistoryProvider.notifier)
                        .changeStatus(BookingStatusFilter.all),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const BookingFilterSheet(),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingS,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const AppText(
              'تعديل',
              style: TextStyle(color: AppColors.primary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class ActiveFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const ActiveFilterChip({
    super.key,
    required this.label,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: AppDimensions.paddingS,
        right: AppDimensions.paddingXS,
        top: AppDimensions.paddingXS,
        bottom: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 2),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

