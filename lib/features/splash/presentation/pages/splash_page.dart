import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/constants/app_constants.dart';
import 'package:qaren/core/constants/app_images.dart';
import 'package:qaren/core/localStorage/cache_helper.dart';
import 'package:qaren/core/theme/app_colors.dart';
import 'package:qaren/features/auth/presentation/pages/login_page.dart';
import 'package:qaren/features/auth/presentation/providers/user_profile_provider.dart';
import 'package:qaren/features/home/presentation/pages/home_page.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => SplashPageState();
}

class SplashPageState extends ConsumerState<SplashPage>{

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _navigate);
  }

  void _navigate() {
    if (!mounted) return;
    final String? token = CacheHelper.getData(key: AppConstants.token) as String?;
    final bool isLoggedIn = token != null && token.isNotEmpty;

    if (isLoggedIn) {
      ref.read(userProfileProvider);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Image.asset(AppImages.splashImg,)
    );
  }
}

