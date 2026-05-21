import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import '../../../domain/entities/booking_service_type.dart';
import '../../../domain/entities/booking_status_filter.dart';
import '../../providers/booking_history_provider.dart';

class BookingFilterSheet extends ConsumerStatefulWidget {
  const BookingFilterSheet({super.key});

  @override
  ConsumerState<BookingFilterSheet> createState() => BookingFilterSheetState();
}

class BookingFilterSheetState extends ConsumerState<BookingFilterSheet> {
  late BookingServiceType selectedService;
  late BookingStatusFilter selectedStatus;

  @override
  void initState() {
    super.initState();
    final state = ref.read(bookingHistoryProvider);
    selectedService = state.selectedServiceType;
    selectedStatus = state.selectedStatus;
  }

  void applyFilters() {
    ref.read(bookingHistoryProvider.notifier).changeServiceType(selectedService);
    ref.read(bookingHistoryProvider.notifier).changeStatus(selectedStatus);
    Navigator.pop(context);
  }

  void resetFilters() {
    setState(() {
      selectedService = BookingServiceType.all;
      selectedStatus = BookingStatusFilter.all;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXL),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Handle bar ──────────────────────────────────────────────────
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: AppDimensions.paddingM),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
              ),
            ),
            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingM,
                AppDimensions.paddingM,
                AppDimensions.paddingM,
                AppDimensions.paddingXS,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText('تصفية الطلبات', style: AppTextStyles.title),
                  TextButton(
                    onPressed: resetFilters,
                    child: const AppText(
                      'إعادة تعيين',
                      style: TextStyle(color: AppColors.error, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.border, height: 1),
            // ── Service type ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingM,
                AppDimensions.paddingM,
                AppDimensions.paddingM,
                AppDimensions.paddingS,
              ),
              child: const AppText('نوع الخدمة', style: AppTextStyles.body),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
              child: Wrap(
                spacing: AppDimensions.paddingS,
                runSpacing: AppDimensions.paddingS,
                children: BookingServiceType.values
                    .where((t) => t != BookingServiceType.unknown)
                    .map((type) => _FilterChip(
                          label: type.label,
                          isSelected: selectedService == type,
                          onTap: () => setState(() => selectedService = type),
                        ))
                    .toList(growable: false),
              ),
            ),
            // ── Status ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingM,
                AppDimensions.paddingL,
                AppDimensions.paddingM,
                AppDimensions.paddingS,
              ),
              child: const AppText('حالة الطلب', style: AppTextStyles.body),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
              child: Wrap(
                spacing: AppDimensions.paddingS,
                runSpacing: AppDimensions.paddingS,
                children: BookingStatusFilter.values
                    .map((status) => _FilterChip(
                          label: status.label,
                          isSelected: selectedStatus == status,
                          onTap: () => setState(() => selectedStatus = status),
                        ))
                    .toList(growable: false),
              ),
            ),
            // ── Apply button ────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.paddingM,
                AppDimensions.paddingL,
                AppDimensions.paddingM,
                AppDimensions.paddingM + MediaQuery.of(context).padding.bottom,
              ),
              child: SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    elevation: 0,
                  ),
                  onPressed: applyFilters,
                  child: const AppText(
                    'تطبيق الفلتر',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : colors.disabledBackground,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: AppText(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : colors.textPrimary,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

