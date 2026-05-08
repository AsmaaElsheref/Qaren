import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_providers.dart';
import 'home_nav_item.dart';

class HomeBottomNav extends ConsumerWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
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
                onTap: (i) => ref.read(bottomNavIndexProvider.notifier).state = i,
              ),
              HomeNavItem(
                icon: Icons.description_outlined,
                index: 1,
                currentIndex: currentIndex,
                onTap: (i) => ref.read(bottomNavIndexProvider.notifier).state = i,
              ),
              const SizedBox(width: 64),
              HomeNavItem(
                icon: Icons.account_balance_wallet_outlined,
                index: 2,
                currentIndex: currentIndex,
                onTap: (i) => ref.read(bottomNavIndexProvider.notifier).state = i,
              ),
              HomeNavItem(
                icon: Icons.person_outline_rounded,
                index: 3,
                currentIndex: currentIndex,
                onTap: (i) => ref.read(bottomNavIndexProvider.notifier).state = i,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
