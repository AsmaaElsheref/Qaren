import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/theme/app_colors_ext.dart';
import 'package:qaren/core/ui/widgets/AppText.dart';
import 'package:qaren/core/ui/widgets/AppTextStyles.dart';

import '../providers/wallet_provider.dart';

class WalletAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const WalletAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    return AppBar(
      backgroundColor: colors.background,
      elevation: 0,
      centerTitle: true,
      title: AppText(
        'المحفظة',
        style: AppTextStyles.title.copyWith(color: colors.textPrimary),
      ),
    );
  }
}
