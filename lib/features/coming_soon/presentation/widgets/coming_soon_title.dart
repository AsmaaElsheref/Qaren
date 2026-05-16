import 'package:flutter/material.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';
class ComingSoonTitle extends StatelessWidget {
  const ComingSoonTitle({super.key});
  @override
  Widget build(BuildContext context) {
    return const AppText(
      'هذه الخدمة ستصبح متاحة قريبا',
      style: AppTextStyles.headline,
      textAlign: TextAlign.center,
    );
  }
}
