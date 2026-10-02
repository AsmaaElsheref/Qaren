import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_images.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/features/auth/presentation/pages/login_page.dart';
import 'package:qaren/features/auth/presentation/providers/user_profile_provider.dart';
import 'package:qaren/features/auth/presentation/providers/auth_session_provider.dart';
import 'package:qaren/features/home/presentation/pages/home_page.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => SplashPageState();
}

class SplashPageState extends ConsumerState<SplashPage> {
  late final Timer _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(const Duration(seconds: 3), _navigate);
  }

  @override
  void dispose() {
    _navigationTimer.cancel();
    super.dispose();
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    final session = await ref.read(authSessionProvider.notifier).restore();
    if (!mounted) return;

    if (!session.isUnauthenticated && session.hasToken) {
      if (session.isAuthenticated) ref.read(userProfileProvider);
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Image.asset(AppImages.splashImg),
    );
  }
}
