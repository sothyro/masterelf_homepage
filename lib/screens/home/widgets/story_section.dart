import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final textTheme = Theme.of(context).textTheme;

    final heading = l10n.sectionStoryHeading;
    final highlightWord = 'Story';
    final highlightIndex = heading.toLowerCase().indexOf(highlightWord.toLowerCase());
    final hasHighlight = highlightIndex >= 0;

    final titleWidget = hasHighlight
        ? RichText(
            text: TextSpan(
              style: (textTheme.headlineMedium ?? textTheme.headlineSmall)?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              children: [
                TextSpan(text: heading.substring(0, highlightIndex)),
                TextSpan(
                  text: heading.substring(highlightIndex, highlightIndex + highlightWord.length),
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextSpan(text: heading.substring(highlightIndex + highlightWord.length)),
              ],
            ),
          )
        : Text(
            heading,
            style: (textTheme.headlineMedium ?? textTheme.headlineSmall)?.copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          );

    final bodyStyle = textTheme.bodyLarge?.copyWith(
      height: 1.65,
      color: AppColors.onPrimary.withValues(alpha: 0.92),
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        titleWidget,
        const SizedBox(height: 28),
        Text(l10n.sectionStoryPara1, style: bodyStyle),
        const SizedBox(height: 16),
        Text(l10n.sectionStoryPara2, style: bodyStyle),
        const SizedBox(height: 16),
        Text(l10n.sectionStoryPara3, style: bodyStyle),
        const SizedBox(height: 32),
        OutlinedButton(
          onPressed: () => context.push('/about'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.onPrimary,
            side: const BorderSide(color: AppColors.accent, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          ),
          child: Text(l10n.sectionStoryCtaButton),
        ),
      ],
    );

    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        AppContent.assetAboutHero,
        height: isMobile ? 280 : 380,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: isMobile ? 280 : 380,
          color: AppColors.surfaceElevatedDark,
          child: const Icon(Icons.image_not_supported_outlined, size: 48, color: AppColors.onPrimary),
        ),
      ),
    );

    return Container(
      width: double.infinity,
      color: AppColors.surfaceDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 56, 32, 48),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          content,
                          const SizedBox(height: 40),
                          imageWidget,
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 48),
                              child: content,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: imageWidget,
                          ),
                        ],
                      ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
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
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.onPrimary.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
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
}
