import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors_ext.dart';
import '../providers/home_providers.dart';
import '../providers/navigation_data_refresher.dart';
import '../../../auth/presentation/guards/guest_access_guard.dart';
import 'home_nav_item.dart';

class HomeBottomNav extends ConsumerWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final colors = context.appColors;

    Future<void> onItemTapped(int index) async {
      if (index != 0 &&
          !await GuestAccessGuard.ensureAuthenticated(
            context: context,
            ref: ref,
          )) {
        return;
      }
      if (!context.mounted) return;
      ref.read(bottomNavIndexProvider.notifier).state = index;
      ref.read(navigationDataRefresherProvider).refresh(index);
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.bottomNavBackground,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              HomeNavItem(
                icon: Icons.home_rounded,
                index: 0,
                currentIndex: currentIndex,
                onTap: onItemTapped,
              ),
              HomeNavItem(
                icon: Icons.description_outlined,
                index: 1,
                currentIndex: currentIndex,
                onTap: onItemTapped,
              ),
              const SizedBox(width: 64),
              HomeNavItem(
                icon: Icons.account_balance_wallet_outlined,
                index: 2,
                currentIndex: currentIndex,
                onTap: onItemTapped,
              ),
              HomeNavItem(
                icon: Icons.person_outline_rounded,
                index: 3,
                currentIndex: currentIndex,
                onTap: onItemTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
