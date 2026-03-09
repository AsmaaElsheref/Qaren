import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_dimensions.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/ui/widgets/AppButton.dart';
import '../../../../../../core/ui/widgets/AppText.dart';

class ConfirmLocationButton extends StatelessWidget {
  const ConfirmLocationButton({super.key, required this.isResolving, required this.isConfirming, required this.title, required this.confirm, required this.addressLabel});

  final bool isResolving;
  final bool isConfirming;
  final String title;
  final String addressLabel;
  final Function() confirm;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.paddingM,
            0,
            AppDimensions.paddingM,
            AppDimensions.paddingM,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Address label card ────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingM,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AppText(
                            title,
                            secondary: true,
                            style: const TextStyle(
                              fontSize: AppDimensions.fontXS,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          const SizedBox(height: 4),
                          isResolving
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AppText(
                                'جاري التحديد...',
                                secondary: true,
                                style: const TextStyle(
                                  fontSize: AppDimensions.fontM,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ) : AppText(
                            addressLabel,
                            style: const TextStyle(
                              fontSize: AppDimensions.fontM,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.right,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingM),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primary,
                        size: AppDimensions.iconS,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              AppButton(
                label: 'تأكيد الموقع',
                icon: Icons.check_circle_outline_rounded,
                isLoading: isConfirming,
                onTap: isResolving ? null : confirm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}