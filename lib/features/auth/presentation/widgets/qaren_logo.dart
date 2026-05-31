import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_images.dart';
import 'package:qaren/core/utils/extensions/contextSizeX.dart';
import '../../../../features/profile/presentation/providers/profileSettings/profile_settings_provider.dart';

class QarenLogo extends ConsumerWidget {
  const QarenLogo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(profileIsDarkModeProvider);
    return Image.asset(
      isDarkMode ? AppImages.qarenDarkMainLogo : AppImages.qarenLogo,
      width: context.screenWidth * 0.35,
      height: context.screenHeight * 0.15,
      fit: BoxFit.cover,
    );
  }
}