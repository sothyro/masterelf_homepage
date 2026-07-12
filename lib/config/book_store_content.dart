import '../l10n/app_localizations.dart';
import 'app_content.dart';

/// Fragment for the top of the Book Store page on /books.
const String kBookStoreSectionFragment = 'books';

/// All book card fragment ids used for deep links from the homepage.
const List<String> kBlessingBookIds = [
  'book-1',
  'book-2',
  'book-3',
  'book-4',
  'book-5',
];

const String kBlessingBundleId = 'blessing-bundle';

const List<String> kPeriod9BookIds = [
  'period9-1',
  'period9-2',
];

/// Whether [fragment] should trigger scroll-to-book behavior (specific book only).
bool isBookStoreDeepLinkFragment(String fragment) {
  if (fragment.isEmpty || fragment == kBookStoreSectionFragment) return false;
  return kBlessingBookIds.contains(fragment) ||
      fragment == kBlessingBundleId ||
      kPeriod9BookIds.contains(fragment);
}

/// Apps route hash for a book card.
String bookStoreRouteForId(String id) => '/books#$id';

/// Single book in the homepage 5-Blessing showcase strip.
class HomeBookShowcaseItem {
  const HomeBookShowcaseItem({
    required this.id,
    required this.coverAsset,
    required this.title,
    required this.subtitle,
  });

  final String id;
  final String coverAsset;
  final String title;
  final String subtitle;
}

/// Book in the Apps store (blessing series or Period 9).
class BookStoreItem {
  const BookStoreItem({
    required this.id,
    required this.coverAsset,
    required this.title,
    required this.subtitle,
    required this.price,
    this.hook,
    this.showBestseller = false,
    this.isBundle = false,
    this.originalPrice,
    this.bundleCoverAssets,
    this.coverAspectRatio = 3 / 4,
  });

  final String id;
  final String coverAsset;
  final String title;
  final String subtitle;
  final String price;
  final String? hook;
  final bool showBestseller;
  final bool isBundle;
  final String? originalPrice;
  final List<String>? bundleCoverAssets;
  final double coverAspectRatio;
}

/// Formatted bundle savings label (e.g. "Save $24.96 vs buying separately").
String bookStoreBundleSavingsLabel(AppLocalizations l10n) {
  final bundle = buildBlessingBundleBook(l10n);
  final original = double.tryParse(bundle.originalPrice ?? '') ?? 0;
  final sale = double.tryParse(bundle.price) ?? 0;
  final savings = original - sale;
  if (savings <= 0) return '';
  final amount = '${l10n.bookStorePricePrefix}${savings.toStringAsFixed(2)}';
  return l10n.bookStoreBundleSaveLabel(amount);
}

/// 5-Blessing series for the Apps book store.
List<BookStoreItem> buildBlessingSeriesBooks(AppLocalizations l10n) {
  return [
    BookStoreItem(
      id: 'book-1',
      coverAsset: AppContent.assetBook1,
      title: l10n.bookStoreBook1Title,
      subtitle: l10n.bookStoreBook1Subtitle,
      price: l10n.bookStoreBook1Price,
      hook: l10n.bookStoreBook1Hook,
      coverAspectRatio: 4 / 5,
    ),
    BookStoreItem(
      id: 'book-2',
      coverAsset: AppContent.assetBook2,
      title: l10n.bookStoreBook2Title,
      subtitle: l10n.bookStoreBook2Subtitle,
      price: l10n.bookStoreBook2Price,
      hook: l10n.bookStoreBook2Hook,
      coverAspectRatio: 4 / 5,
    ),
    BookStoreItem(
      id: 'book-3',
      coverAsset: AppContent.assetBook3,
      title: l10n.bookStoreBook3Title,
      subtitle: l10n.bookStoreBook3Subtitle,
      price: l10n.bookStoreBook3Price,
      hook: l10n.bookStoreBook3Hook,
      coverAspectRatio: 4 / 5,
    ),
    BookStoreItem(
      id: 'book-4',
      coverAsset: AppContent.assetBook4,
      title: l10n.bookStoreBook4Title,
      subtitle: l10n.bookStoreBook4Subtitle,
      price: l10n.bookStoreBook4Price,
      hook: l10n.bookStoreBook4Hook,
      coverAspectRatio: 4 / 5,
    ),
    BookStoreItem(
      id: 'book-5',
      coverAsset: AppContent.assetBook5,
      title: l10n.bookStoreBook5Title,
      subtitle: l10n.bookStoreBook5Subtitle,
      price: l10n.bookStoreBook5Price,
      hook: l10n.bookStoreBook5Hook,
      coverAspectRatio: 4 / 5,
    ),
  ];
}

/// Complete 5-Blessing bundle for the Apps book store (fills row 3).
BookStoreItem buildBlessingBundleBook(AppLocalizations l10n) {
  return BookStoreItem(
    id: kBlessingBundleId,
    coverAsset: AppContent.assetBook1,
    title: l10n.bookStoreBlessingBundleTitle,
    subtitle: l10n.bookStoreBlessingBundleSubtitle,
    price: l10n.bookStoreBlessingBundlePrice,
    hook: l10n.bookStoreBlessingBundleHook,
    originalPrice: l10n.bookStoreBlessingBundleOriginalPrice,
    isBundle: true,
    bundleCoverAssets: const [
      AppContent.assetBook1,
      AppContent.assetBook2,
      AppContent.assetBook3,
      AppContent.assetBook4,
      AppContent.assetBook5,
    ],
    coverAspectRatio: 4 / 5,
  );
}

/// Five blessing volumes plus bundle card for the Apps store grid.
List<BookStoreItem> buildBlessingSeriesStoreItems(AppLocalizations l10n) {
  return [
    ...buildBlessingSeriesBooks(l10n),
    buildBlessingBundleBook(l10n),
  ];
}

/// Period 9 Feng Shui volumes (restored store cards).
List<BookStoreItem> buildPeriod9Books(AppLocalizations l10n) {
  return [
    BookStoreItem(
      id: 'period9-1',
      coverAsset: AppContent.assetPeriod9Book1,
      title: l10n.bookStorePeriod9Book1Title,
      subtitle: l10n.bookStorePeriod9Book1Subtitle,
      price: l10n.bookStorePeriod9Book1Price,
      hook: l10n.bookStorePeriod9Book1Hook,
      showBestseller: true,
    ),
    BookStoreItem(
      id: 'period9-2',
      coverAsset: AppContent.assetPeriod9Book2,
      title: l10n.bookStorePeriod9Book2Title,
      subtitle: l10n.bookStorePeriod9Book2Subtitle,
      price: l10n.bookStorePeriod9Book2Price,
      hook: l10n.bookStorePeriod9Book2Hook,
    ),
  ];
}

/// Five homepage book pillars in the 5-Blessing series.
List<HomeBookShowcaseItem> buildHomeBookShowcase(AppLocalizations l10n) {
  return buildBlessingSeriesBooks(l10n)
      .map(
        (book) => HomeBookShowcaseItem(
          id: book.id,
          coverAsset: book.coverAsset,
          title: book.title,
          subtitle: book.subtitle,
        ),
      )
      .toList();
}
