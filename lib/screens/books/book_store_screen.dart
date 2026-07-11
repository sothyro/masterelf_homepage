import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/book_store_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../store/widgets/marketplace_category_strip.dart';
import '../store/widgets/section_anchor.dart';
import '../store/widgets/store_content_container.dart';
import '../store/widgets/store_page_hero.dart';
import 'widgets/book_store_marketing.dart';
import 'widgets/book_store_period9_bridge.dart';
import 'widgets/book_store_section.dart';
import 'widgets/book_store_shelf_panorama.dart';

/// Dedicated Book Store page at /books.
class BookStoreScreen extends StatefulWidget {
  const BookStoreScreen({super.key});

  @override
  State<BookStoreScreen> createState() => _BookStoreScreenState();
}

class _BookStoreScreenState extends State<BookStoreScreen> {
  final GlobalKey _keyBooks = GlobalKey();

  late final Map<String, GlobalKey> _bookScrollKeys = {
    for (final id in [
      ...kBlessingBookIds,
      kBlessingBundleId,
      ...kPeriod9BookIds,
    ])
      id: GlobalKey(),
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollToTargetIfNeeded();
  }

  void _scrollToTargetIfNeeded() {
    final fragment = GoRouterState.of(context).uri.fragment;
    if (fragment.isEmpty) return;
    final width = MediaQuery.sizeOf(context).width;
    final isBookDeepLink = isBookStoreDeepLinkFragment(fragment);
    if (Breakpoints.isMobile(width) && !isBookDeepLink) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final key = switch (fragment) {
        kBookStoreSectionFragment => _keyBooks,
        _ when _bookScrollKeys.containsKey(fragment) => _bookScrollKeys[fragment],
        _ => null,
      };
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.15,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StorePageHero(
            title: l10n.bookStoreSectionHeading,
            description: l10n.bookStoreSectionTagline,
            descriptionHighlight: l10n.bookStoreSectionTaglineHighlight,
            heroHeightNarrow: 520,
            heroHeightWide: 480,
          ),
          StoreContentContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                MarketplaceCategoryStrip(l10n: l10n),
                const SizedBox(height: 32),
                BookStoreMarketingIntro(l10n: l10n),
                const SizedBox(height: 40),
                SectionAnchor(
                  key: _keyBooks,
                  child: BookStoreSection(
                    l10n: l10n,
                    bookScrollKeys: _bookScrollKeys,
                    showPageHeading: false,
                    scope: BookStoreSectionScope.blessingOnly,
                  ),
                ),
              ],
            ),
          ),
          BookStoreShelfPanorama(l10n: l10n),
          BookStorePeriod9Bridge(l10n: l10n),
          StoreContentContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                BookStoreSection(
                  l10n: l10n,
                  bookScrollKeys: _bookScrollKeys,
                  showPageHeading: false,
                  scope: BookStoreSectionScope.period9Only,
                ),
                const SizedBox(height: 48),
                BookStoreTrustBand(l10n: l10n),
                const SizedBox(height: 32),
                BookStoreClosingCta(l10n: l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
