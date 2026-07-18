import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';

import '../providers/notifications_provider.dart';

class MarkAllReadButton extends ConsumerWidget {
  const MarkAllReadButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(
      notificationsProvider.select((state) => state.unreadCount),
    );
    final isLoading = ref.watch(
      notificationsProvider.select((state) => state.isMarkingAllRead),
    );
    final enabled = unreadCount > 0 && !isLoading;

    return TextButton(
      onPressed: enabled
          ? () async {
              final messenger = ScaffoldMessenger.of(context);
              final success = await ref
                  .read(notificationsProvider.notifier)
                  .markAllRead();
              if (!context.mounted || !success) return;
              messenger.showSnackBar(
                SnackBar(
                  content: AppText('notifications.markAllReadSuccess'.tr()),
                ),
              );
            }
          : null,
      child: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            )
          : AppText(
              'notifications.markAllRead'.tr(),
              style: TextStyle(
                color: enabled ? AppColors.primary : AppColors.textHint,
                fontSize: 12,
              ),
            ),
    );
  }
}
