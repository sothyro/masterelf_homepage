import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../store/widgets/marketplace_category_strip.dart';
import '../store/widgets/store_content_container.dart';
import '../store/widgets/store_page_hero.dart';
import 'widgets/talisman_grid.dart';
import 'widgets/talisman_store_marketing.dart';

/// Dedicated Talisman Store page at /talisman.
class TalismanStoreScreen extends StatelessWidget {
  const TalismanStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StorePageHero(
            title: l10n.talismanStoreSpotlightTitle,
            description: l10n.talismanStoreSpotlightTagline,
            descriptionHighlight: l10n.talismanStoreSpotlightTaglineHighlight,
            heroHeightNarrow: 480,
            heroHeightWide: 440,
          ),
          StoreContentContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                MarketplaceCategoryStrip(l10n: l10n),
                const SizedBox(height: 32),
                TalismanStoreMarketingIntro(l10n: l10n),
                const SizedBox(height: 40),
                TalismanStoreCollectionIntro(l10n: l10n),
                const SizedBox(height: 24),
                TalismanGrid(l10n: l10n),
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
