import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/providers/locale_provider.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:masterelf_homepage/utils/breakpoints.dart';
import 'package:masterelf_homepage/widgets/app_header.dart';
import 'package:provider/provider.dart';

void main() {
  Future<void> pumpHeader(WidgetTester tester, {required double width}) async {
    await tester.binding.setSurfaceSize(Size(width, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => MediaQuery(
            data: MediaQueryData(size: Size(width, 800)),
            child: Scaffold(
              body: Column(
                children: [
                  AppHeader(onOpenDrawer: () {}),
                  const Expanded(child: SizedBox.expand()),
                ],
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/contact',
          builder: (context, state) => const Scaffold(body: Text('contact')),
        ),
      ],
    );

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => LocaleNotifier(),
        child: MaterialApp.router(
          theme: AppTheme.dark(),
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('mobile header at 390px does not overflow', (tester) async {
    expect(Breakpoints.isMobile(390), isTrue);
    await pumpHeader(tester, width: 390);

    expect(tester.takeException(), isNull);
    expect(find.byType(AppHeader), findsOneWidget);
    expect(find.text('Contact'), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
  });

  testWidgets('mobile header at 360px does not overflow', (tester) async {
    await pumpHeader(tester, width: 360);
    expect(tester.takeException(), isNull);
    expect(find.text('Contact'), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
  });
}
