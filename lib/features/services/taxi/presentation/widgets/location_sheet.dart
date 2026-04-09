import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/ui/widgets/AppText.dart';
import '../providers/taxi_notifier.dart';
import 'map/destination_field.dart';
import 'map/pickup_field.dart';
import 'price_compare_button.dart';

class LocationSheet extends ConsumerWidget {
  const LocationSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingM,
        AppDimensions.paddingM,
        AppDimensions.paddingM,
        AppDimensions.paddingM + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
          ),
          PickupField(),
          const SizedBox(height: AppDimensions.paddingM),
          DestinationField(),
          const SizedBox(height: AppDimensions.paddingM),
          // ── Date pickers ──────────────────────────────────────────────
          const _DatePickersRow(),
          const SizedBox(height: AppDimensions.paddingL),
          const PriceCompareButton(),
          const SizedBox(height: AppDimensions.paddingS),
        ],
      ),
    );
  }
}

// ── Date pickers row ────────────────────────────────────────────────────────────

class _DatePickersRow extends ConsumerWidget {
  const _DatePickersRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taxiProvider);

    return Row(
      children: [
        Expanded(
          child: _DateTile(
            label: 'تاريخ الاستلام',
            date: state.pickupDate,
            onTap: () => _pickDate(
              context: context,
              initial: state.pickupDate,
              firstDate: DateTime.now(),
              onPicked: (d) => ref.read(taxiProvider.notifier).setPickupDate(d),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingS),
        Expanded(
          child: _DateTile(
            label: 'تاريخ الإرجاع',
            date: state.returnDate,
            onTap: () => _pickDate(
              context: context,
              initial: state.returnDate,
              firstDate: state.pickupDate ?? DateTime.now(),
              onPicked: (d) => ref.read(taxiProvider.notifier).setReturnDate(d),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate({
    required BuildContext context,
    DateTime? initial,
    required DateTime firstDate,
    required void Function(DateTime) onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? firstDate.add(const Duration(days: 1)),
      firstDate: firstDate,
      lastDate: firstDate.add(const Duration(days: 365)),
    );
    if (picked != null) onPicked(picked);
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  const _DateTile({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = date != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimensions.inputHeight,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: AppDimensions.paddingS),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textHint,
                    ),
                  ),
                  AppText(
                    hasValue ? _formatDate(date!) : 'اختر التاريخ',
                    style: TextStyle(
                      fontSize: AppDimensions.fontS,
                      fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                      color: hasValue ? AppColors.textPrimary : AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
