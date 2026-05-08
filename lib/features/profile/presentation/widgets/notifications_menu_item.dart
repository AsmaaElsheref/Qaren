import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profileSettings/profile_settings_provider.dart';
import 'notification_badge.dart';
import 'settings_menu_item.dart';

class NotificationsMenuItem extends ConsumerWidget {
  final VoidCallback? onTap;

  const NotificationsMenuItem({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only rebuilds when unread count changes
    final unreadCount = ref.watch(profileUnreadCountProvider);

    return SettingsMenuItem(
      icon: Icons.notifications_outlined,
      iconColor: const Color(0xFFF4A730),
      iconBackground: const Color(0xFFFFF3E0),
      label: 'الإشعارات',
      onTap: onTap,
      trailing: unreadCount > 0 ? NotificationBadge(count: unreadCount) : null,
    );
  }
}

