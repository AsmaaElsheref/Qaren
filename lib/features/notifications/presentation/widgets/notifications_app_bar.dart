import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import 'mark_all_read_button.dart';

class NotificationsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NotificationsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
      ),
      title: const AppText('الإشعارات', style: AppTextStyles.title),
      actions: const [MarkAllReadButton()],
    );
  }
}

