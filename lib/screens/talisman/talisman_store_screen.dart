import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_asset_preloader.dart';
import '../../utils/breakpoints.dart';
import '../../utils/mobile_web_performance.dart';
import '../../widgets/editorial_page_hero.dart';
import '../store/widgets/marketplace_category_strip.dart';
import '../store/widgets/store_content_container.dart';
import 'talisman_load_coordinator.dart';
import 'widgets/talisman_grid.dart';
import 'widgets/talisman_store_marketing.dart';

/// Dedicated Talisman Store page at /talisman.
class TalismanStoreScreen extends StatefulWidget {
  const TalismanStoreScreen({super.key});

  @override
  State<TalismanStoreScreen> createState() => _TalismanStoreScreenState();
}

class _TalismanStoreScreenState extends State<TalismanStoreScreen> {
  final _collectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    AppAssetPreloader.preloadTalismanPageAssets();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      TalismanLoadCoordinator.armAfterReveal();
    });
  }

  void _scrollToCollection() {
    final context = _collectionKey.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDesktop = Breakpoints.isDesktop(MediaQuery.sizeOf(context).width);

    return Material(
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            child: EditorialPageHero(
              isDesktop: isDesktop,
              backgroundAsset: AppContent.assetContactHero,
              backgroundCacheWidth:
                  MobileWebPerformance.heroBackgroundCacheWidth(context),
              label: l10n.talismanStore,
              headline: l10n.talismanStoreSpotlightTagline,
              body: l10n.talismanStoreIntroBody,
              primaryCta: l10n.talismanStoreHeroBrowseCta,
              secondaryCta: l10n.talismanStoreClosingCta,
              onPrimary: _scrollToCollection,
              onSecondary: () => context.push('/consultations'),
            ),
          ),
          StoreContentContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                RepaintBoundary(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MarketplaceCategoryStrip(l10n: l10n),
                      const SizedBox(height: 32),
                      TalismanStoreMarketingIntro(l10n: l10n),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                RepaintBoundary(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KeyedSubtree(
                        key: _collectionKey,
                        child: TalismanStoreCollectionIntro(l10n: l10n),
                      ),
                      const SizedBox(height: 24),
                      TalismanGrid(l10n: l10n),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                TalismanStoreTrustBand(l10n: l10n),
                const SizedBox(height: 32),
                TalismanStoreClosingCta(l10n: l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
