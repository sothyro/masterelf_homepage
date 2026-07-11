import 'package:flutter/material.dart';

import '../../../config/book_store_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../store/widgets/description_with_highlight.dart';
import 'book_store_period9_header.dart';
import 'book_store_card.dart';
import 'book_store_marketing.dart';

/// Scope for [BookStoreSection] when the shelf panorama splits the page layout.
enum BookStoreSectionScope { all, blessingOnly, period9Only }

/// Book Store grid: 5-Blessing series + bundle + Period 9 volumes.
class BookStoreSection extends StatelessWidget {
  const BookStoreSection({
    super.key,
    required this.l10n,
    required this.bookScrollKeys,
    this.showPageHeading = true,
    this.scope = BookStoreSectionScope.all,
  });

  final AppLocalizations l10n;
  final Map<String, GlobalKey> bookScrollKeys;
  final bool showPageHeading;
  final BookStoreSectionScope scope;

  static const double _rowGap = 24;
  static const double _columnGap = 24;

  Widget _buildBooks(List<BookStoreItem> books, {required bool singleColumn}) {
    if (singleColumn) {
      return Column(
        children: [
          for (var i = 0; i < books.length; i++) ...[
            if (i > 0) const SizedBox(height: _rowGap),
            _bookCard(books[i]),
          ],
        ],
      );
    }
    return _buildTwoPerRowBooks(books);
  }

  Widget _buildTwoPerRowBooks(List<BookStoreItem> books) {
    return Column(
      children: [
        for (var i = 0; i < books.length; i += 2) ...[
          if (i > 0) const SizedBox(height: _rowGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _bookCard(books[i])),
              const SizedBox(width: _columnGap),
              Expanded(
                child: i + 1 < books.length
                    ? _bookCard(books[i + 1])
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _bookCard(BookStoreItem book) {
    return BookStoreCard(
      key: bookScrollKeys[book.id],
      l10n: l10n,
      asset: book.coverAsset,
      title: book.title,
      subtitle: book.subtitle,
      hook: book.hook,
      price: book.price,
      coverAspectRatio: book.coverAspectRatio,
      showBestseller: book.showBestseller,
      isBundle: book.isBundle,
      bundleCoverAssets: book.bundleCoverAssets,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = !Breakpoints.isDesktop(width);
    final singleColumn = Breakpoints.isMobile(width);
    final blessingBooks = buildBlessingSeriesStoreItems(l10n);
    final period9Books = buildPeriod9Books(l10n);
    final showBlessing =
        scope == BookStoreSectionScope.all || scope == BookStoreSectionScope.blessingOnly;
    final showPeriod9 =
        scope == BookStoreSectionScope.all || scope == BookStoreSectionScope.period9Only;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showPageHeading && showBlessing) ...[
          Text(
            l10n.bookStoreSectionHeading,
            style: highlightStyleForLocale(
              context,
              fontSize: isNarrow ? 28 : 34,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 8),
          DescriptionWithHighlight(
            description: l10n.bookStoreSectionTagline,
            highlightPhrase: l10n.bookStoreSectionTaglineHighlight,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 16),
          DescriptionWithHighlight(
            description: l10n.bookStoreSectionMarketing,
            highlightPhrase: l10n.bookStoreSectionMarketingHighlight,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 32),
        ],
        if (showBlessing) ...[
          BookStoreSeriesIntro(
            heading: l10n.bookStoreBlessingSeriesHeading,
            description: l10n.bookStoreBlessingSeriesIntro,
            highlightPhrase: l10n.bookStoreBlessingSeriesIntroHighlight,
          ),
          const SizedBox(height: 20),
          _buildBooks(blessingBooks, singleColumn: singleColumn),
        ],
        if (showPeriod9) ...[
          if (showBlessing) const SizedBox(height: 40),
          BookStorePeriod9SeriesHeader(l10n: l10n),
          const SizedBox(height: 20),
          _buildBooks(period9Books, singleColumn: singleColumn),
        ],
      ],
    );
  }
}
