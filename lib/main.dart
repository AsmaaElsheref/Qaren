import 'package:qaren/core/localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qaren/core/ui/widgets/loading.dart';
import 'package:qaren/features/services/taxi/presentation/widgets/searching/search_loading.dart';

import 'core/localization/app_locales.dart';
import 'core/localStorage/cache_helper.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_provider.dart';
import 'features/services/taxi/presentation/pages/searching/searching.dart';
import 'features/splash/presentation/pages/splash_page.dart';

Future<void> main() async {
  debugPrint('[startup] main entered');
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('[startup] Flutter binding initialized');
  await EasyLocalization.ensureInitialized();
  debugPrint('[startup] EasyLocalization initialized');
  await dotenv.load(fileName: '.env');
  debugPrint('[startup] dotenv loaded');
  await CacheHelper.init();
  debugPrint('[startup] cache initialized');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supportedLocales,
      path: AppLocales.translationsPath,
      fallbackLocale: AppLocales.fallbackLocale,
      saveLocale: true,
      useOnlyLangCode: true,
      child: const ProviderScope(child: QarenApp()),
    ),
  );
  debugPrint('[startup] runApp called');
}

class QarenApp extends ConsumerWidget {
  const QarenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(appThemeModeProvider);
    Intl.defaultLocale = context.locale.toLanguageTag();

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
