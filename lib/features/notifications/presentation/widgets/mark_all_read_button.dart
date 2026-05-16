import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';

import '../providers/notifications_provider.dart';

class MarkAllReadButton extends ConsumerWidget {
  const MarkAllReadButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(notificationsProvider.select((state) => state.unreadCount));
    final isLoading = ref.watch(notificationsProvider.select((state) => state.isMarkingAllRead));
    final enabled = unreadCount > 0 && !isLoading;

    return TextButton(
      onPressed: enabled
          ? () async {
              final messenger = ScaffoldMessenger.of(context);
              final success = await ref.read(notificationsProvider.notifier).markAllRead();
              if (!context.mounted || !success) return;
              messenger.showSnackBar(
                const SnackBar(content: AppText('تم تحديد كل الإشعارات كمقروءة')),
              );
            }
          : null,
      child: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
            )
          : AppText(
              'تحديد الكل كمقروء',
              style: TextStyle(color: enabled ? AppColors.primary : AppColors.textHint, fontSize: 12),
            ),
    );
  }
}

