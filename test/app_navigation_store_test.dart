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
  testWidgets('AppDrawer Apps section has three store links without Period 9', (tester) async {
    final localeNotifier = LocaleNotifier();
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(
            drawer: AppDrawer(),
            body: SizedBox.shrink(),
          ),
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

    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Master Elf System'), findsOneWidget);
    expect(find.text('Book Store'), findsOneWidget);
    expect(find.text('Talisman Store'), findsOneWidget);
    expect(find.text('Period 9 Mobile App'), findsNothing);
  });
}
