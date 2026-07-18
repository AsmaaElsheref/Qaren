// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qaren/core/localization/app_locales.dart';
import 'package:qaren/core/localization/easy_localization.dart';

import 'package:qaren/main.dart';

void main() {
  testWidgets('QarenApp smoke test', (WidgetTester tester) async {
    await EasyLocalization.ensureInitialized();

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: AppLocales.supportedLocales,
        path: AppLocales.translationsPath,
        fallbackLocale: AppLocales.fallbackLocale,
        child: const ProviderScope(child: QarenApp()),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
