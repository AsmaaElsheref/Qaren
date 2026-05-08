import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';
import 'package:qaren/core/constants/app_dimensions.dart';
import 'package:qaren/features/home/presentation/providers/home_providers.dart';
class ComingSoonActionButton extends ConsumerWidget {
  const ComingSoonActionButton({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () => ref.read(bottomNavIndexProvider.notifier).state = 0,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          elevation: 0,
        ),
        child: const AppText(
          'العودة للرئيسية',
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
