import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  /// Phrases to highlight in story body (matched in order; works across locales where present).
  static const List<String> _bodyHighlightPhrases = [
    '50%',
    '44,000',
    'Chinese Metaphysics',
    'proven method',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    // Heading: Dangrek for Khmer, Exo2 otherwise; highlight "Story" where present
    final heading = l10n.sectionStoryHeading;
    final highlightWord = 'Story';
    final highlightIndex = heading.toLowerCase().indexOf(highlightWord.toLowerCase());
    final hasHighlight = highlightIndex >= 0;
    final isKm = Localizations.localeOf(context).languageCode == 'km';

    final headingStyle = isKm
        ? GoogleFonts.dangrek(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w700,
            fontSize: isMobile ? 30 : 40,
            height: 1.25,
            letterSpacing: 0,
          )
        : GoogleFonts.exo2(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w700,
            fontSize: isMobile ? 30 : 40,
            height: 1.25,
          );
    final headingHighlightStyle = highlightStyleForLocale(
      context,
      color: AppColors.accent,
      fontWeight: FontWeight.bold,
      fontSize: (isMobile ? 38 : 52),
      height: 1.25,
    );

    final titleWidget = hasHighlight
        ? RichText(
            text: TextSpan(
              style: headingStyle,
              children: [
                TextSpan(text: heading.substring(0, highlightIndex)),
                TextSpan(text: heading.substring(highlightIndex, highlightIndex + highlightWord.length), style: headingHighlightStyle),
                TextSpan(text: heading.substring(highlightIndex + highlightWord.length)),
              ],
            ),
          )
        : Text(heading, style: headingStyle);

    // Body: Siem Reap for Khmer, Exo2 otherwise; optional phrase highlights
    final bodyBase = isKm
        ? GoogleFonts.siemreap(
            fontSize: isMobile ? 18 : 20,
            height: 1.7,
            color: AppColors.onPrimary.withValues(alpha: 0.92),
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          )
        : GoogleFonts.exo2(
            fontSize: isMobile ? 18 : 20,
            height: 1.7,
            color: AppColors.onPrimary.withValues(alpha: 0.92),
            fontWeight: FontWeight.w400,
          );
    final bodyHighlight = isKm
        ? GoogleFonts.siemreap(
            fontSize: isMobile ? 18 : 20,
            height: 1.7,
            color: AppColors.accent,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          )
        : highlightStyleForLocale(
            context,
            fontSize: isMobile ? 18 : 20,
            height: 1.7,
            color: AppColors.accent,
            fontWeight: FontWeight.w600,
          );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        titleWidget,
        const SizedBox(height: 28),
        RichText(
          text: TextSpan(
            style: bodyBase,
            children: _highlightPhrases(l10n.sectionStoryPara1, _bodyHighlightPhrases, bodyBase, bodyHighlight),
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: bodyBase,
            children: _highlightPhrases(l10n.sectionStoryPara2, _bodyHighlightPhrases, bodyBase, bodyHighlight),
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: bodyBase,
            children: _highlightPhrases(l10n.sectionStoryPara3, _bodyHighlightPhrases, bodyBase, bodyHighlight),
          ),
        ),
        const SizedBox(height: 32),
        OutlinedButton(
          onPressed: () => context.push('/journey'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.onPrimary,
            side: const BorderSide(color: AppColors.accent, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            textStyle: isKm
                ? GoogleFonts.siemreap(fontSize: isMobile ? 17 : 19, fontWeight: FontWeight.w600, letterSpacing: 0)
                : GoogleFonts.exo2(fontSize: isMobile ? 17 : 19, fontWeight: FontWeight.w600),
          ),
          child: Text(l10n.sectionStoryCtaButton),
        ),
      ],
    );

    // Story block: text only (no image)
    final storyPadding = isMobile ? const EdgeInsets.fromLTRB(16, 24, 16, 32) : const EdgeInsets.fromLTRB(32, 168, 32, 168);

    final storyBlock = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: content,
      ),
    );

    // Desktop: centered story block. Mobile: image full height behind text (stacked), with light scrim for readability.
    final storyContent = isMobile
        ? Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 820),
              child: Stack(
                children: [
                  // Give Stack a size so positioned children have a layout (Stack with only positioned children otherwise has zero size).
                  SizedBox(width: double.infinity, height: 820),
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        AppContent.assetStoryBackground,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.2),
                            Colors.black.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 24, 12, 24),
                      child: storyBlock,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: storyPadding,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: storyBlock,
              ),
            ),
          );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGlow.withValues(alpha: 0.35),
            blurRadius: 100,
            offset: const Offset(-80, 0),
            spreadRadius: -90,
          ),
          BoxShadow(
            color: AppColors.accentGlow.withValues(alpha: 0.35),
            blurRadius: 100,
            offset: const Offset(80, 0),
            spreadRadius: -90,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.borderDark.withValues(alpha: 0.8),
          width: 1,
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1C1C1E),
            Color(0xFF141416),
            Color(0xFF0C0C0E),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: _ChineseTilePainter(),
                ),
              ),
            ),
            // Desktop only: decorative image at bottom-right. On mobile we show image at top of content column instead.
            if (!isMobile)
              Positioned(
                right: 0,
                top: 48,
                bottom: 0,
                width: 800,
                child: Opacity(
                  opacity: 0.77,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      AppContent.assetStoryBackground,
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                storyContent,
              ],
            ),
          ],
        ),
      ),
    );
  }

  static List<InlineSpan> _highlightPhrases(
    String text,
    List<String> phrases,
    TextStyle normal,
    TextStyle highlight,
  ) {
    final List<InlineSpan> result = [];
    int start = 0;
    while (start < text.length) {
      int nextIndex = -1;
      String? matched;
      for (final phrase in phrases) {
        if (phrase.isEmpty) continue;
        final idx = text.indexOf(phrase, start);
        if (idx >= 0 && (nextIndex < 0 || idx < nextIndex)) {
          nextIndex = idx;
          matched = phrase;
        }
      }
      if (nextIndex < 0) {
        result.add(TextSpan(text: text.substring(start), style: normal));
        break;
      }
      if (nextIndex > start) {
        result.add(TextSpan(text: text.substring(start, nextIndex), style: normal));
      }
      result.add(TextSpan(text: matched, style: highlight));
      start = nextIndex + (matched?.length ?? 0);
    }
    return result;
  }
}

/// Paints a subtle Chinese-style tile/lattice pattern that blends over the gradient.
class _ChineseTilePainter extends CustomPainter {
  _ChineseTilePainter();

  /// Size of one 回纹 (key/fret) pattern unit.
  static const double _unitSize = 36.0;
  static const double _lineOpacity = 0.032;
  static const double _accentOpacity = 0.018;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppColors.onPrimary.withValues(alpha: _lineOpacity)
      ..strokeWidth = 0.9
      ..style = PaintingStyle.stroke;

    final accentPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: _accentOpacity)
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    final u = _unitSize;
    final g = u * 0.35; // gap / step size for the key pattern

    for (double oy = 0; oy < size.height + u; oy += u) {
      for (double ox = 0; ox < size.width + u; ox += u) {
        canvas.save();
        canvas.translate(ox, oy);

        // 回纹 (huíwén) key/fret pattern: broken square with stepped sides
        final pts = <Offset>[
          Offset(0, u),
          Offset(0, g),
          Offset(g, g),
          Offset(g, 0),
          Offset(u - g, 0),
          Offset(u - g, g),
          Offset(u, g),
          Offset(u, u - g),
          Offset(u - g, u - g),
          Offset(u - g, u),
          Offset(g, u),
          Offset(g, u - g),
          Offset(0, u - g),
          Offset(0, u),
        ];
        for (int i = 0; i < pts.length - 1; i++) {
          canvas.drawLine(pts[i], pts[i + 1], linePaint);
        }

        // Small inner diamond (菱形) accent in the center of the unit
        final cx = u / 2;
        final cy = u / 2;
        final d = u * 0.18;
        canvas.drawLine(Offset(cx - d, cy), Offset(cx + d, cy), accentPaint);
        canvas.drawLine(Offset(cx, cy - d), Offset(cx, cy + d), accentPaint);
        canvas.drawLine(Offset(cx - d * 0.7, cy - d * 0.7), Offset(cx + d * 0.7, cy + d * 0.7), accentPaint);
        canvas.drawLine(Offset(cx + d * 0.7, cy - d * 0.7), Offset(cx - d * 0.7, cy + d * 0.7), accentPaint);

        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
