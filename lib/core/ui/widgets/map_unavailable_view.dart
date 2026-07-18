import 'package:flutter/material.dart';
import 'package:qaren/core/localization/easy_localization.dart';

import '../../constants/app_dimensions.dart';
import '../../theme/app_colors.dart';
import 'AppText.dart';

class MapUnavailableView extends StatelessWidget {
  const MapUnavailableView({
    super.key,
    this.titleKey = 'common.mapUnavailable.title',
    this.messageKey = 'common.mapUnavailable.message',
  });

  final String titleKey;
  final String messageKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.map_outlined,
                  color: AppColors.textSecondary,
                  size: 34,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              AppText(
                titleKey.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppDimensions.fontL,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingS),
              AppText(
                messageKey.tr(),
                textAlign: TextAlign.center,
                secondary: true,
                style: const TextStyle(
                  fontSize: AppDimensions.fontS,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
