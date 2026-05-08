import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/pages/profileSettings/profile_settings_page.dart';
import '../providers/home_providers.dart';
import '../widgets/home_ai_fab.dart';
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
      appBar: HomeAppBar(showSearch: navIndex == 0),
      drawer: const ProfileSettingsPage(),
      body: screens[navIndex],
      bottomNavigationBar: const HomeBottomNav(),
      floatingActionButton: const HomeAiFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

