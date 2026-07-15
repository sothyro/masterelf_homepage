import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:masterelf_homepage/l10n/app_localizations.dart';
import 'package:masterelf_homepage/screens/books/book_store_screen.dart';
import 'package:masterelf_homepage/screens/books/books_load_coordinator.dart';
import 'package:masterelf_homepage/utils/app_asset_preloader.dart';
import 'package:masterelf_homepage/screens/books/widgets/book_store_card.dart';
import 'package:masterelf_homepage/screens/books/widgets/book_store_period9_bridge.dart';
import 'package:masterelf_homepage/screens/books/widgets/book_store_period9_header.dart';
import 'package:masterelf_homepage/screens/books/widgets/book_store_shelf_panorama.dart';
import 'package:masterelf_homepage/theme/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    BooksLoadCoordinator.resetForTesting();
    AppAssetPreloader.resetForTesting();
    AppAssetPreloader.disableImageDecodeForTesting = true;
    AppAssetPreloader.disableBackgroundFontsForTesting = true;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
  });

  Future<void> settleBookStoreTimers(WidgetTester tester) async {
    await tester.pump(BooksLoadCoordinator.idleFallback);
    await tester.pump(const Duration(seconds: 5));
  }

  Future<void> pumpBookStoreScreen(
    WidgetTester tester, {
    required double width,
    required double height,
  }) async {
    await tester.binding.setSurfaceSize(Size(width, height));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp.router(
        theme: AppTheme.dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (_, __) => MediaQuery(
                data: MediaQueryData(size: Size(width, height)),
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: width,
                    child: const BookStoreScreen(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> revealDeferredBookSections(WidgetTester tester) async {
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -3200));
    await tester.pump();
    VisibilityDetectorController.instance.notifyNow();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(BooksLoadCoordinator.idleFallback);
  }

  testWidgets('BookStoreScreen renders blessing and bundle cards', (tester) async {
    await pumpBookStoreScreen(tester, width: 1280, height: 3600);
    await revealDeferredBookSections(tester);

    expect(find.byType(BookStoreScreen), findsOneWidget);
    expect(find.text('Books that earn a place on your desk'), findsOneWidget);
    expect(find.text('Built for real decisions'), findsOneWidget);
    expect(find.text('Not sure where to start?'), findsOneWidget);
    expect(find.text('The 5-Blessing Book Series'), findsOneWidget);
    expect(find.text('Complete 5-Blessing Bundle'), findsOneWidget);
    expect(find.text('Period 9 Feng Shui Collection'), findsOneWidget);
    expect(find.byType(BookStoreShelfPanorama), findsOneWidget);
    expect(find.byKey(BookStoreShelfPanorama.panoramaKey), findsOneWidget);
    expect(find.text('Introducing The Five Blessings Series'), findsOneWidget);
    expect(find.text('Own the complete reference set'), findsOneWidget);
    expect(find.text('Continue your library with Period 9'), findsOneWidget);
    expect(find.text('Period 9 · 2024–2043'), findsOneWidget);
    expect(find.text('Advanced Feng Shui · Two-Volume Set'), findsOneWidget);
    expect(find.byKey(BookStorePeriod9Bridge.bridgeKey), findsOneWidget);
    expect(find.byKey(BookStorePeriod9SeriesHeader.headerKey), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(BookStoreShelfPanorama),
        matching: find.byType(Image),
      ),
      findsOneWidget,
    );
    final panoramaTop = tester.getTopLeft(
      find.byKey(BookStoreShelfPanorama.panoramaKey),
    ).dy;
    final bridgeTop = tester.getTopLeft(
      find.byKey(BookStorePeriod9Bridge.bridgeKey),
    ).dy;
    final period9Top = tester.getTopLeft(
      find.byKey(BookStorePeriod9SeriesHeader.headerKey),
    ).dy;
    expect(bridgeTop, greaterThan(panoramaTop));
    expect(period9Top, greaterThan(bridgeTop));
    expect(find.text('Add Bundle to Cart'), findsOneWidget);
    expect(
      find.text('Shape your space for flow, wealth, and calm at home.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
    await settleBookStoreTimers(tester);
  });

  testWidgets('BookStoreScreen stacks books in a single column on mobile', (tester) async {
    await pumpBookStoreScreen(tester, width: 375, height: 3600);
    await revealDeferredBookSections(tester);

    expect(find.text('Books that earn a place on your desk'), findsOneWidget);
    expect(find.text('The 5-Blessing Book Series'), findsOneWidget);
    expect(find.text('Complete 5-Blessing Bundle'), findsOneWidget);
    expect(find.byKey(BookStoreShelfPanorama.panoramaKey), findsOneWidget);

    final cards = find.byType(BookStoreCard);
    expect(cards, findsWidgets);
    final firstBottom = tester.getBottomLeft(cards.first).dy;
    final secondTop = tester.getTopLeft(cards.at(1)).dy;
    expect(secondTop, greaterThan(firstBottom));
    expect(tester.takeException(), isNull);
    await settleBookStoreTimers(tester);
  });

  testWidgets('BookStoreScreen has no overflow at tablet width', (tester) async {
    await pumpBookStoreScreen(tester, width: 768, height: 3600);
    expect(tester.takeException(), isNull);
    await settleBookStoreTimers(tester);
  });
}
