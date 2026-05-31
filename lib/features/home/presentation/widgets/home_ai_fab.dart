import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/providers/profileSettings/profile_settings_provider.dart';

class HomeAiFab extends ConsumerWidget {
  const HomeAiFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final isDarkMode = ref.watch(profileIsDarkModeProvider);
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(
        isDarkMode ? AppImages.qarenDarkLogo : AppImages.Logo,
      ),
    );
  }
}
