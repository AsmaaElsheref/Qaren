import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/localization/app_locales.dart';
import 'core/localization/locale_service.dart';
import 'core/localStorage/cache_helper.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_provider.dart';
import 'features/splash/presentation/pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await CacheHelper.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final startLocale = LocaleService.readSavedLocale();

  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supportedLocales,
      path: AppLocales.translationsPath,
      fallbackLocale: AppLocales.fallbackLocale,
      startLocale: startLocale,
      saveLocale: true,
      child: const ProviderScope(child: QarenApp()),
    ),
  );
}

class QarenApp extends ConsumerWidget {
  const QarenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp(
      title: 'app.name'.tr(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const SplashPage(),
    );
  }
}
