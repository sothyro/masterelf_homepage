import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/screens/books/books_load_coordinator.dart';
import 'package:masterelf_homepage/screens/events/events_load_coordinator.dart';
import 'package:masterelf_homepage/screens/talisman/talisman_load_coordinator.dart';
import 'package:masterelf_homepage/utils/app_asset_preloader.dart';

void main() {
  setUp(() {
    BooksLoadCoordinator.resetForTesting();
    EventsLoadCoordinator.resetForTesting();
    TalismanLoadCoordinator.resetForTesting();
    AppAssetPreloader.resetForTesting();
    AppAssetPreloader.disableBackgroundFontsForTesting = true;
    AppAssetPreloader.disableImageDecodeForTesting = true;
  });

  group('BooksLoadCoordinator', () {
    test('does not start background preload before arm', () {
      BooksLoadCoordinator.onBooksScroll(pixels: 500, maxScrollExtent: 1000);
      expect(AppAssetPreloader.backgroundPreloadStarted, isFalse);
    });

    test('starts background preload after scroll threshold when armed', () {
      BooksLoadCoordinator.armAfterReveal();
      BooksLoadCoordinator.onBooksScroll(pixels: 300, maxScrollExtent: 1000);
      expect(AppAssetPreloader.backgroundPreloadStarted, isTrue);
    });

    test('idle fallback triggers after arm', () async {
      BooksLoadCoordinator.armAfterReveal();
      expect(AppAssetPreloader.backgroundPreloadStarted, isFalse);
      await Future<void>.delayed(BooksLoadCoordinator.idleFallback);
      expect(AppAssetPreloader.backgroundPreloadStarted, isTrue);
    });
  });

  group('EventsLoadCoordinator', () {
    test('does not start background preload before arm', () {
      EventsLoadCoordinator.onEventsScroll(pixels: 500, maxScrollExtent: 1000);
      expect(AppAssetPreloader.backgroundPreloadStarted, isFalse);
    });

    test('starts background preload after scroll threshold when armed', () {
      EventsLoadCoordinator.armAfterReveal();
      EventsLoadCoordinator.onEventsScroll(pixels: 300, maxScrollExtent: 1000);
      expect(AppAssetPreloader.backgroundPreloadStarted, isTrue);
    });

    test('idle fallback triggers after arm', () async {
      EventsLoadCoordinator.armAfterReveal();
      expect(AppAssetPreloader.backgroundPreloadStarted, isFalse);
      await Future<void>.delayed(EventsLoadCoordinator.idleFallback);
      expect(AppAssetPreloader.backgroundPreloadStarted, isTrue);
    });
  });

  group('TalismanLoadCoordinator', () {
    test('does not start background preload before arm', () {
      TalismanLoadCoordinator.onTalismanScroll(pixels: 500, maxScrollExtent: 1000);
      expect(AppAssetPreloader.backgroundPreloadStarted, isFalse);
    });

    test('starts background preload after scroll threshold when armed', () {
      TalismanLoadCoordinator.armAfterReveal();
      TalismanLoadCoordinator.onTalismanScroll(pixels: 300, maxScrollExtent: 1000);
      expect(AppAssetPreloader.backgroundPreloadStarted, isTrue);
    });
  });
}
