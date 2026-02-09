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
      fontSize: isMobile ? 26 : 34,
      height: 1.25,
    );
    final headingHighlightStyle = GoogleFonts.condiment(
      color: AppColors.accent,
      fontWeight: FontWeight.bold,
      fontSize: (isMobile ? 32 : 44),
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
      fontSize: isMobile ? 15 : 17,
      height: 1.7,
      color: AppColors.onPrimary.withValues(alpha: 0.92),
      fontWeight: FontWeight.w400,
    );
    final bodyHighlight = GoogleFonts.exo2(
      fontSize: isMobile ? 15 : 17,
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
          ),
          child: Text(l10n.sectionStoryCtaButton),
        ),
      ],
    );

    // Story block: background image + overlay + left-aligned text; responsive min height on mobile
    final sectionMinHeight = isMobile ? 420.0 : 720.0;
    final storyPadding = isMobile ? const EdgeInsets.fromLTRB(16, 40, 16, 32) : const EdgeInsets.fromLTRB(32, 56, 32, 48);
    final storyBlock = Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            AppContent.assetStoryBackground,
            fit: BoxFit.cover,
            alignment: const Alignment(0, -1),
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.surfaceDark,
              child: const Center(
                child: Icon(Icons.image_not_supported_outlined, size: 48, color: AppColors.onPrimary),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.primary.withValues(alpha: 0.88),
                  AppColors.primary.withValues(alpha: 0.72),
                  AppColors.primary.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: storyPadding,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: content,
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      color: AppColors.surfaceDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: sectionMinHeight,
            child: storyBlock,
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.featuredIn,
                        style: GoogleFonts.condiment(
                          fontSize: 44,
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
                      ),
                      const SizedBox(width: 32),
                      ...List.generate(
                        6,
                        (i) => Padding(
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
                                'Logo ${i + 1}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.onPrimary.withValues(alpha: 0.5),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
