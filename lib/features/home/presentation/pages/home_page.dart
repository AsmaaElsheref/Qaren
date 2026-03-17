import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_providers.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_bottom_nav.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screens = ref.watch(navigationScreens);
    final navIndex = ref.watch(bottomNavIndexProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HomeAppBar(showSearch: navIndex==0,),
      body: screens[navIndex],
      bottomNavigationBar: const HomeBottomNav(),
      floatingActionButton: _AiFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// ── AI Centre FAB ──────────────────────────────────────────────────────────────
class _AiFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(
        Icons.smart_toy_outlined,
        color: AppColors.white,
        size: 26,
      ),
    );
  }
}

