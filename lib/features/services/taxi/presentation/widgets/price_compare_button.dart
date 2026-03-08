import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../providers/taxi_providers.dart';

/// Compare-prices CTA button.
///
/// Watches only [taxiIsLoadingProvider] and [taxiCanCompareProvider]
/// so it rebuilds ONLY when loading state or field-filled state changes —
/// never when the user is typing individual characters.
class PriceCompareButton extends ConsumerWidget {
  const PriceCompareButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(taxiIsLoadingProvider);
    final canCompare = ref.watch(taxiCanCompareProvider);

    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: canCompare
              ? AppColors.primaryGradient
              : const LinearGradient(
                  colors: [Color(0xFFE0E0E0), Color(0xFFD5D5D5)],
                ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: canCompare
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            onTap: canCompare && !isLoading
                ? () => ref.read(taxiProvider.notifier).comparePrices()
                : null,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'مقارنة الأسعار',
                          style: TextStyle(
                            fontSize: AppDimensions.fontM,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Cairo',
                            color: canCompare
                                ? AppColors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.paddingS),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: AppDimensions.iconS,
                          color: canCompare
                              ? AppColors.white
                              : AppColors.textSecondary,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

