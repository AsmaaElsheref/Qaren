import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'core/localStorage/cache_helper.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();
 
  final String? token = CacheHelper.getData(key: AppConstants.token) as String?;
  final Widget initialPage =
      (token != null && token.isNotEmpty) ? const HomePage() : const LoginPage();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    ProviderScope(
      child: QarenApp(initialPage: initialPage),
    ),
  );
}

class QarenApp extends StatelessWidget {
  const QarenApp({super.key, required this.initialPage});

  final Widget initialPage;

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
      home: initialPage,
    );
  }
}
