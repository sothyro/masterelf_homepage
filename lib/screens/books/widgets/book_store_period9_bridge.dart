import 'package:flutter/material.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../store/widgets/description_with_highlight.dart';

/// Visual bridge between the Five Blessings shelf panorama and Period 9 series.
class BookStorePeriod9Bridge extends StatelessWidget {
  const BookStorePeriod9Bridge({super.key, required this.l10n});

  final AppLocalizations l10n;

  static const Key bridgeKey = ValueKey<String>('book-store-period9-bridge');

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    final horizontalPadding = isNarrow ? 16.0 : 24.0;

    return Container(
      key: bridgeKey,
      width: width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0908),
            Color(0xFF120E0A),
            Color(0xFF1A120C),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _BridgeGoldBorder(),
          Padding(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 32, horizontalPadding, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  children: [
                    Text(
                      l10n.bookStorePeriod9BridgeHeading,
                      textAlign: TextAlign.center,
                      style: highlightStyleForLocale(
                        context,
                        fontSize: isNarrow ? 22 : 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _TwinCoverPreview(
                      isNarrow: isNarrow,
                      volume1Label: l10n.bookStorePeriod9Book1Subtitle,
                      volume2Label: l10n.bookStorePeriod9Book2Subtitle,
                    ),
                    const SizedBox(height: 20),
                    DescriptionWithHighlight(
                      description: l10n.bookStorePeriod9BridgeBody,
                      highlightPhrase: l10n.bookStorePeriod9BridgeHighlight,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const _BridgeGoldBorder(),
        ],
      ),
    );
  }
}

class _TwinCoverPreview extends StatelessWidget {
  const _TwinCoverPreview({
    required this.isNarrow,
    required this.volume1Label,
    required this.volume2Label,
  });

  final bool isNarrow;
  final String volume1Label;
  final String volume2Label;

  @override
  Widget build(BuildContext context) {
    final coverWidth = isNarrow ? 64.0 : 88.0;
    final coverHeight = coverWidth * 1.35;
    final gap = isNarrow ? 16.0 : 28.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CoverThumbnail(
          asset: AppContent.assetPeriod9Book1,
          label: volume1Label,
          width: coverWidth,
          height: coverHeight,
        ),
        SizedBox(width: gap),
        _CoverThumbnail(
          asset: AppContent.assetPeriod9Book2,
          label: volume2Label,
          width: coverWidth,
          height: coverHeight,
        ),
      ],
    );
  }
}

class _CoverThumbnail extends StatelessWidget {
  const _CoverThumbnail({
    required this.asset,
    required this.label,
    required this.width,
    required this.height,
  });

  final String asset;
  final String label;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.65),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentGlow.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Image.asset(
            asset,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
            errorBuilder: (_, __, ___) => ColoredBox(
              color: AppColors.surfaceDark,
              child: Icon(
                Icons.menu_book_outlined,
                color: AppColors.accent.withValues(alpha: 0.5),
                size: width * 0.35,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: width,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.85),
                  letterSpacing: 0.3,
                  height: 1.25,
                ),
          ),
        ),
      ],
    );
  }
}

class _BridgeGoldBorder extends StatelessWidget {
  const _BridgeGoldBorder();

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
