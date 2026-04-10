import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/localStorage/cache_helper.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/providers/user_profile_provider.dart';
import 'features/home/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();

  final String? token = CacheHelper.getData(key: AppConstants.token) as String?;
  final bool isLoggedIn = token != null && token.isNotEmpty;

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    ProviderScope(
      child: QarenApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class QarenApp extends StatelessWidget {
  const QarenApp({super.key, required this.isLoggedIn});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qaren',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: const Locale('ar'),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: isLoggedIn ? const _AuthenticatedEntry() : const LoginPage(),
    );
  }
}

/// Entry point for authenticated users.
///
/// Triggers [userProfileProvider] to silently fetch and cache the user's name
/// and phone if they are missing (e.g. first launch after token restore),
/// then immediately renders [HomePage].  The fetch is fire-and-forget so the
/// user is never blocked by this network call.
class _AuthenticatedEntry extends ConsumerWidget {
  const _AuthenticatedEntry();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kick off the profile fetch without blocking the UI.
    ref.watch(userProfileProvider);
    return const HomePage();
  }
}

