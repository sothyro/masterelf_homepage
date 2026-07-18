import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/providers/locale_provider.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:masterelf_homepage/widgets/app_header.dart';

void main() {
  Future<LocaleNotifier> pumpHeader(
    WidgetTester tester, {
    required String initialLocale,
    Size surfaceSize = const Size(375, 900),
  }) async {
    final localeNotifier = LocaleNotifier()..setLocaleFromCode(initialLocale);
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => Scaffold(
            body: Column(
              children: [
                AppHeader(onOpenDrawer: () {}),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ),
      ],
    );

    await tester.binding.setSurfaceSize(surfaceSize);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: localeNotifier,
        child: ListenableBuilder(
          listenable: localeNotifier,
          builder: (context, _) => MaterialApp.router(
            theme: AppTheme.dark(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: localeNotifier.locale,
            routerConfig: router,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return localeNotifier;
  }

  testWidgets('mobile: can return to English from Khmer via flag tap', (tester) async {
    final notifier = await pumpHeader(tester, initialLocale: 'km');
    expect(notifier.locale.languageCode, 'km');

    await tester.tap(find.text('🇸🇬'));
    await tester.pumpAndSettle();

    expect(notifier.locale.languageCode, 'en');
  });

  testWidgets('mobile: can return to English from Chinese via flag tap', (tester) async {
    final notifier = await pumpHeader(tester, initialLocale: 'zh');
    expect(notifier.locale.languageCode, 'zh');

    await tester.tap(find.text('🇸🇬'));
    await tester.pumpAndSettle();

    expect(notifier.locale.languageCode, 'en');
  });

  testWidgets('mobile: Khmer and Chinese flags still switch locale', (tester) async {
    final notifier = await pumpHeader(tester, initialLocale: 'en');

    await tester.tap(find.text('🇰🇭'));
    await tester.pumpAndSettle();
    expect(notifier.locale.languageCode, 'km');

    await tester.tap(find.text('🇨🇳'));
    await tester.pumpAndSettle();
    expect(notifier.locale.languageCode, 'zh');
  });
}
