import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/providers/auth_provider.dart';
import 'package:masterelf_homepage/providers/locale_provider.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:masterelf_homepage/widgets/app_drawer.dart';

import 'test_helpers/fake_auth.dart';

void main() {
  Future<LocaleNotifier> pumpDrawer(WidgetTester tester) async {
    final localeNotifier = LocaleNotifier();
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => Scaffold(
            drawer: const AppDrawer(),
            body: const SizedBox(),
          ),
        ),
        GoRoute(
          path: '/journey',
          builder: (_, __) => const Scaffold(body: Text('Journey page')),
        ),
      ],
    );

    await tester.binding.setSurfaceSize(const Size(375, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: localeNotifier),
          ChangeNotifierProvider(create: (_) => AuthProvider(authService: FakeLoggedInAuthService())),
        ],
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

  testWidgets('drawer Journey tile navigates to /journey', (tester) async {
    await pumpDrawer(tester);
    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    await tester.tap(find.text('My Endeavour'));
    await tester.pumpAndSettle();

    expect(find.text('Journey page'), findsOneWidget);
  });

  testWidgets('drawer KM chip calls setLocaleFromCode', (tester) async {
    final localeNotifier = await pumpDrawer(tester);
    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(localeNotifier.locale.languageCode, 'en');
    await tester.tap(find.text('KM'));
    await tester.pumpAndSettle();

    expect(localeNotifier.locale.languageCode, 'km');
  });
}
