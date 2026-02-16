import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';

/// Number of logo placeholders in the Featured in section (15 = 3 pages × 5 logos).
const int _kFeaturedLogoCount = 15;
const int _kLogosPerLine = 5;
const int _kFeaturedLogoPages = 3; // 15 / 5

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
    final textTheme = Theme.of(context).textTheme;
    final isMobile = Breakpoints.isMobile(width);

    // Heading: new font + highlight "Story"
    final heading = l10n.sectionStoryHeading;
    final highlightWord = 'Story';
    final highlightIndex = heading.toLowerCase().indexOf(highlightWord.toLowerCase());
    final hasHighlight = highlightIndex >= 0;

    final headingStyle = GoogleFonts.exo2(
      color: AppColors.onPrimary,
      fontWeight: FontWeight.w700,
      fontSize: isMobile ? 30 : 40,
      height: 1.25,
    );
    final headingHighlightStyle = GoogleFonts.condiment(
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

    // Body: Lora with optional phrase highlights
    final bodyBase = GoogleFonts.exo2(
      fontSize: isMobile ? 18 : 20,
      height: 1.7,
      color: AppColors.onPrimary.withValues(alpha: 0.92),
      fontWeight: FontWeight.w400,
    );
    final bodyHighlight = GoogleFonts.exo2(
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
            textStyle: GoogleFonts.exo2(fontSize: isMobile ? 17 : 19, fontWeight: FontWeight.w600),
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

    // On mobile: position text lower (towards bottom of section); desktop: keep centered
    final storyContent = isMobile
        ? SizedBox(
            height: 420,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: storyBlock,
              ),
            ),
          )
        : Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: storyBlock,
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
            Positioned(
              right: 0,
              bottom: 0,
              width: isMobile ? 380 : 800,
              height: isMobile ? 440 : 850,
              child: Opacity(
                opacity: 0.77,
                child: Image.asset(
                  AppContent.assetStoryBackground,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Padding(
                padding: storyPadding,
                child: storyContent,
              ),
              Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: isMobile ? 16 : 32),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              border: Border(
                top: BorderSide(color: AppColors.borderDark, width: 1),
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: _FeaturedInCarousel(
                  l10n: l10n,
                  textTheme: textTheme,
                ),
              ),
            ),
          ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildLogoChip(
    AppLocalizations l10n,
    TextTheme textTheme,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Container(
        width: 88,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderDark, width: 1),
        ),
        child: Center(
          child: Text(
            l10n.logoPlaceholder(index),
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.5),
              fontSize: 13,
            ),
          ),
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

/// Fade-in / fade-out logo strip: 5 logos per row, 3 rows (15 logos), looping.
class _FeaturedInCarousel extends StatefulWidget {
  const _FeaturedInCarousel({
    required this.l10n,
    required this.textTheme,
  });

  final AppLocalizations l10n;
  final TextTheme textTheme;

  @override
  State<_FeaturedInCarousel> createState() => _FeaturedInCarouselState();
}

class _FeaturedInCarouselState extends State<_FeaturedInCarousel> {
  int _currentPage = 0;
  Timer? _timer;
  static const double _headerGap = 32;
  static const Duration _slideDuration = Duration(milliseconds: 1200);
  static const Duration _displayDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_displayDuration, (_) {
      if (!mounted) return;
      setState(() {
        _currentPage = (_currentPage + 1) % _kFeaturedLogoPages;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final textTheme = widget.textTheme;

    final header = Text(
      l10n.featuredIn,
      style: GoogleFonts.condiment(
        fontSize: 52,
        fontWeight: FontWeight.bold,
        color: AppColors.accent,
        height: 1.2,
        shadows: [
          Shadow(
            color: AppColors.accent.withValues(alpha: 0.4),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
    );

    final startIndex = _currentPage * _kLogosPerLine;
    final logosRow = Row(
      mainAxisSize: MainAxisSize.min,
      key: ValueKey<int>(_currentPage),
      children: [
        for (var i = 0; i < _kLogosPerLine; i++)
          StorySection._buildLogoChip(l10n, textTheme, startIndex + i + 1),
      ],
    );

    return Row(
      children: [
        header,
        const SizedBox(width: _headerGap),
        Expanded(
          child: Center(
            child: AnimatedSwitcher(
              duration: _slideDuration,
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: logosRow,
            ),
          ),
        ),
      ],
    );
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
