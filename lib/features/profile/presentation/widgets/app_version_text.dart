import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/ui/widgets/AppText.dart';
import '../../../../core/ui/widgets/AppTextStyles.dart';

class AppVersionText extends StatelessWidget {
  final String version;

  const AppVersionText({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: AppText(
          'common.version'.tr(namedArgs: {'version': version}),
          style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
        ),
      ),
    );
  }
}
