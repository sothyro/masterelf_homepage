import 'package:flutter_test/flutter_test.dart';
import 'package:masterelf_homepage/config/app_content.dart';
import 'package:masterelf_homepage/config/book_store_content.dart';
import 'package:masterelf_homepage/l10n/app_localizations_en.dart';

void main() {
  test('buildBlessingSeriesBooks returns five 4:5 books', () {
    final l10n = AppLocalizationsEn();
    final books = buildBlessingSeriesBooks(l10n);

    expect(books, hasLength(5));
    expect(books.map((b) => b.id), kBlessingBookIds);
    expect(books.every((b) => b.coverAspectRatio == 4 / 5), isTrue);
    expect(books[0].title, 'Modern Feng Shui');
    expect(books[0].coverAsset, AppContent.assetBook1);
  });

  test('buildPeriod9Books returns two restored Period 9 volumes', () {
    final l10n = AppLocalizationsEn();
    final books = buildPeriod9Books(l10n);

    expect(books, hasLength(2));
    expect(books[0].id, 'period9-1');
    expect(books[0].title, 'Period 9 Feng Shui — Volume 1');
    expect(books[0].subtitle, 'Foundations & Flying Stars');
    expect(books[0].coverAsset, AppContent.assetPeriod9Book1);
    expect(books[0].showBestseller, isTrue);
    expect(books[1].coverAsset, AppContent.assetPeriod9Book2);
  });

  test('bookStoreRouteForId builds apps deep link', () {
    expect(bookStoreRouteForId('book-3'), '/books#book-3');
    expect(isBookStoreDeepLinkFragment('book-5'), isTrue);
    expect(isBookStoreDeepLinkFragment('period9-2'), isTrue);
    expect(isBookStoreDeepLinkFragment('books'), isTrue);
    expect(isBookStoreDeepLinkFragment('talisman'), isFalse);
  });

  test('buildHomeBookShowcase maps blessing books without price', () {
    final l10n = AppLocalizationsEn();
    final home = buildHomeBookShowcase(l10n);
    expect(home, hasLength(5));
    expect(home.first.title, 'Modern Feng Shui');
  });

  test('buildBlessingSeriesStoreItems includes bundle card', () {
    final l10n = AppLocalizationsEn();
    final items = buildBlessingSeriesStoreItems(l10n);

    expect(items, hasLength(6));
    expect(items.last.id, kBlessingBundleId);
    expect(items.last.isBundle, isTrue);
    expect(items.last.title, 'Complete 5-Blessing Bundle');
    expect(items.last.price, '99.99');
    expect(items.last.originalPrice, '124.95');
    expect(items.last.hook, isNotEmpty);
    expect(items.last.bundleCoverAssets, hasLength(5));
  });

  test('buildBlessingSeriesBooks includes hooks on each volume', () {
    final l10n = AppLocalizationsEn();
    final books = buildBlessingSeriesBooks(l10n);

    expect(books.every((b) => b.hook != null && b.hook!.isNotEmpty), isTrue);
    expect(books.first.hook, 'Shape your space for flow, wealth, and calm at home.');
  });

  test('bookStoreBundleSavingsLabel computes save amount from prices', () {
    final l10n = AppLocalizationsEn();
    expect(bookStoreBundleSavingsLabel(l10n), 'Save \$24.96 vs buying separately');
  });
}
