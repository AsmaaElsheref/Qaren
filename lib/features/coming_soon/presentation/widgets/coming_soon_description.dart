import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

class ComingSoonDescription extends StatelessWidget {
  const ComingSoonDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return AppText(
      'comingSoon.description'.tr(),
      style: AppTextStyles.bodySecondary,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
