import 'package:flutter/material.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';
class ComingSoonDescription extends StatelessWidget {
  const ComingSoonDescription({super.key});
  @override
  Widget build(BuildContext context) {
    return const AppText(
      'نعمل حاليًا على تجهيز هذه الصفحة وستكون متاحة لك قريبًا.',
      style: AppTextStyles.bodySecondary,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
