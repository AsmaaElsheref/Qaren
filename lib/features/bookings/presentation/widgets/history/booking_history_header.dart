import 'package:flutter/material.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';
import 'package:qaren/core/ui/widgets/icon_container.dart';

import 'booking_filter_sheet.dart';

class BookingHistoryHeader extends StatelessWidget implements PreferredSizeWidget {
  const BookingHistoryHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AppBar(
      elevation: 0,
      centerTitle: true,
      actionsPadding: EdgeInsets.only(left: 20),
      title: const AppText('طلباتي', style: AppTextStyles.title),
      actions: [
        IconContainer(
          icon: Icon(Icons.tune_rounded, color: colors.textPrimary),
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const BookingFilterSheet(),
          ),
        ),
      ],
    );
  }
}
