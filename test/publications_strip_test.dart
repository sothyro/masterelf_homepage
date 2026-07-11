import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:masterelf_homepage/config/book_store_content.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/home/widgets/publications_strip.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
  });

  Future<void> pumpPublicationsStrip(
    WidgetTester tester, {
    required double width,
    GoRouter? router,
  }) async {
    await tester.binding.setSurfaceSize(Size(width, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final widget = MediaQuery(
      data: MediaQueryData(size: Size(width, 900)),
      child: const PublicationsStrip(),
    );

    if (router != null) {
      await tester.pumpWidget(
        MaterialApp.router(
          theme: AppTheme.dark(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      );
    } else {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: SingleChildScrollView(
              child: SizedBox(
                width: width,
                child: widget,
              ),
            ),
          ),
        ),
      );
    }

    await tester.pump();
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump(const Duration(milliseconds: 500));
  }

  Future<void> disposePublicationsStrip(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump();
  }

  testWidgets('PublicationsStrip shows one book at a time on mobile', (tester) async {
    await pumpPublicationsStrip(tester, width: 375);
    expect(tester.takeException(), isNull);
    expect(find.text('The 5-Blessing Book Series'), findsOneWidget);
    expect(find.text('Modern Feng Shui'), findsOneWidget);
    expect(find.text('Applied Qi Men Dun Jia'), findsNothing);
    expect(find.text('View all books'), findsOneWidget);
    expect(find.byType(AspectRatio), findsOneWidget);
    await disposePublicationsStrip(tester);
  });

  testWidgets('PublicationsStrip mobile carousel advances after 2 seconds', (tester) async {
    await pumpPublicationsStrip(tester, width: 375);
    expect(find.text('Modern Feng Shui'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(tester.takeException(), isNull);
    expect(find.text('Applied Qi Men Dun Jia'), findsOneWidget);
    await disposePublicationsStrip(tester);
  });

  testWidgets('PublicationsStrip has no overflow at desktop width', (tester) async {
    await pumpPublicationsStrip(tester, width: 1280);
    expect(tester.takeException(), isNull);
    expect(find.byType(PublicationsStrip), findsOneWidget);
    expect(find.text('Applied Qi Men Dun Jia'), findsOneWidget);
    expect(find.text('Ze Ri'), findsOneWidget);
    expect(find.text('The Sacred Art of Timing for Power, Hope & Destiny'), findsOneWidget);
    expect(find.byType(AspectRatio), findsNWidgets(5));
  });

  testWidgets('tapping a book navigates to per-book books deep link', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => MediaQuery(
            data: const MediaQueryData(size: Size(1280, 900)),
            child: const Scaffold(body: PublicationsStrip()),
          ),
        ),
        GoRoute(
          path: '/books',
          builder: (context, state) => Scaffold(
            body: Text('books:${state.uri.fragment}'),
          ),
        ),
      ],
    );

    await pumpPublicationsStrip(tester, width: 1280, router: router);

    await tester.tap(find.text('Strategic I Ching'));
    await tester.pumpAndSettle();

    expect(find.text('books:book-3'), findsOneWidget);
    expect(bookStoreRouteForId('book-3'), '/books#book-3');
  });
}
