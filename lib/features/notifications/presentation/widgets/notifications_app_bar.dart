import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import 'mark_all_read_button.dart';

class NotificationsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NotificationsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AppBar(
      backgroundColor: colors.background,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.textPrimary),
      ),
      title: AppText(
        'الإشعارات',
        style: AppTextStyles.title.copyWith(color: colors.textPrimary),
      ),
      actions: const [MarkAllReadButton()],
    );
  }
}
