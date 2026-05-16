import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors.dart';

class NotificationReadIndicator extends StatelessWidget {
  final bool isUnread;

  const NotificationReadIndicator({
    super.key,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    if (!isUnread) return const SizedBox(width: 8, height: 8);

    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}

