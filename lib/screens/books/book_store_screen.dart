import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_content.dart';
import '../../config/book_store_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_asset_preloader.dart';
import '../../utils/breakpoints.dart';
import '../../utils/mobile_web_performance.dart';
import '../../widgets/app_shell_scroll_scope.dart';
import '../../widgets/editorial_page_hero.dart';
import '../store/widgets/marketplace_category_strip.dart';
import '../store/widgets/section_anchor.dart';
import '../store/widgets/store_content_container.dart';
import 'books_load_coordinator.dart';
import 'widgets/book_store_marketing.dart';
import 'widgets/book_store_period9_bridge.dart';
import 'widgets/book_store_section.dart';
import 'widgets/book_store_shelf_panorama.dart';
import 'widgets/books_deferred_section.dart';

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
  void initState() {
    super.initState();
    AppAssetPreloader.preloadBooksPageAssets();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      BooksLoadCoordinator.armAfterReveal();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollToTargetIfNeeded();
  }

  void _scrollToTargetIfNeeded() {
    final fragment = GoRouterState.of(context).uri.fragment;
    if (fragment.isEmpty || fragment == kBookStoreSectionFragment) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final key = _bookScrollKeys[fragment];
      if (key != null) {
        ensureShellSectionVisible(context, key);
      }
    });
  }

  void _scrollToBooks() {
    ensureShellSectionVisible(context, _keyBooks);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = Breakpoints.isDesktop(width);
    final isMobile = Breakpoints.isMobile(width);
    final fragment = GoRouterState.of(context).uri.fragment;
    final eagerPeriod9 = isBookStoreDeepLinkFragment(fragment);

    return Material(
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RepaintBoundary(
            child: EditorialPageHero(
              isDesktop: isDesktop,
              backgroundAsset: AppContent.assetContactHero,
              backgroundCacheWidth:
                  MobileWebPerformance.heroBackgroundCacheWidth(context),
              label: l10n.bookStoreNav,
              headline: l10n.bookStoreSectionTagline,
              body: l10n.bookStoreIntroBody,
              primaryCta: l10n.bookStoreHeroBrowseCta,
              secondaryCta: l10n.bookStoreClosingCta,
              onPrimary: _scrollToBooks,
              onSecondary: () => context.push('/consultations'),
            ),
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
                RepaintBoundary(
                  child: SectionAnchor(
                    key: _keyBooks,
                    child: BookStoreSection(
                      l10n: l10n,
                      bookScrollKeys: _bookScrollKeys,
                      showPageHeading: false,
                      scope: BookStoreSectionScope.blessingOnly,
                    ),
                  ),
                ),
              ],
            ),
          ),
          BooksDeferredSection(
            sectionKey: 'shelf-panorama',
            placeholderHeight: isMobile ? 400 : 520,
            child: RepaintBoundary(
              child: BookStoreShelfPanorama(l10n: l10n),
            ),
          ),
          BooksDeferredSection(
            sectionKey: 'period9-bridge',
            placeholderHeight: 320,
            eager: eagerPeriod9,
            child: RepaintBoundary(
              child: BookStorePeriod9Bridge(l10n: l10n),
            ),
          ),
          StoreContentContainer(
            child: BooksDeferredSection(
              sectionKey: 'period9-section',
              placeholderHeight: isMobile ? 600 : 720,
              eager: eagerPeriod9,
              child: RepaintBoundary(
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
            ),
          ),
        ],
      ),
    );
  }
}
