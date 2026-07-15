import 'package:flutter/material.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../utils/mobile_web_performance.dart';
import '../../store/widgets/description_with_highlight.dart';

/// Full-viewport shelf mockup between the 5-Blessing grid and Period 9 series.
class BookStoreShelfPanorama extends StatelessWidget {
  const BookStoreShelfPanorama({super.key, required this.l10n});

  final AppLocalizations l10n;

  static const Key panoramaKey = ValueKey<String>('book-store-shelf-panorama');

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    final horizontalPadding = isNarrow ? 16.0 : 24.0;
    final shelfCacheWidth = MobileWebPerformance.devicePixelCacheWidth(context, width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 40, horizontalPadding, 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: _ShelfPanoramaMarketingBand(
                heading: l10n.bookStoreShelfPanoramaTopHeading,
                body: l10n.bookStoreShelfPanoramaTopBody,
                highlightPhrase: l10n.bookStoreShelfPanoramaTopHighlight,
                isNarrow: isNarrow,
              ),
            ),
          ),
        ),
        const _ShelfPanoramaBorder(),
        SizedBox(
          key: panoramaKey,
          width: width,
          child: Image.asset(
            AppContent.assetShelfMockupFiveBlessings,
            width: width,
            fit: BoxFit.fitWidth,
            alignment: Alignment.center,
            cacheWidth: shelfCacheWidth,
            filterQuality: MobileWebPerformance.imageFilterQuality(context),
            semanticLabel: l10n.bookStoreShelfPanoramaSemanticLabel,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
        const _ShelfPanoramaBorder(),
        Padding(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 40),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: _ShelfPanoramaMarketingBand(
                heading: l10n.bookStoreShelfPanoramaBottomHeading,
                body: l10n.bookStoreShelfPanoramaBottomBody,
                highlightPhrase: l10n.bookStoreShelfPanoramaBottomHighlight,
                isNarrow: isNarrow,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShelfPanoramaMarketingBand extends StatelessWidget {
  const _ShelfPanoramaMarketingBand({
    required this.heading,
    required this.body,
    required this.highlightPhrase,
    required this.isNarrow,
  });

  final String heading;
  final String body;
  final String highlightPhrase;
  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          heading,
          textAlign: TextAlign.center,
          style: highlightStyleForLocale(
            context,
            fontSize: isNarrow ? 22 : 28,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        DescriptionWithHighlight(
          description: body,
          highlightPhrase: highlightPhrase,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ShelfPanoramaBorder extends StatelessWidget {
  const _ShelfPanoramaBorder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.accent.withValues(alpha: 0.55),
            AppColors.accent.withValues(alpha: 0.85),
            AppColors.accent.withValues(alpha: 0.55),
            Colors.transparent,
          ],
          stops: const [0.0, 0.15, 0.5, 0.85, 1.0],
        ),
      ),
    );
  }
}
