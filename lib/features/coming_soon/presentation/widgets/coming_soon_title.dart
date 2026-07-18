import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

class ComingSoonTitle extends StatelessWidget {
  const ComingSoonTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return AppText(
      'comingSoon.title'.tr(),
      style: AppTextStyles.headline,
      textAlign: TextAlign.center,
    );
  }
}
