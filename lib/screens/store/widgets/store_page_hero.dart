import 'package:flutter/material.dart';

import '../../../config/app_content.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../widgets/page_content_inset.dart';
import 'description_with_highlight.dart';

/// Shared hero block for Apps, Book Store, and Talisman Store pages.
class StorePageHero extends StatelessWidget {
  const StorePageHero({
    super.key,
    required this.title,
    required this.description,
    required this.descriptionHighlight,
    this.titleContent,
    this.bottomChild,
    this.backgroundAsset = AppContent.assetContactHero,
    this.heroHeightNarrow = 780,
    this.heroHeightWide = 720,
    this.backgroundCacheWidth,
  });

  final String title;
  final String description;
  final String descriptionHighlight;
  /// When set, replaces the default title + description block.
  final Widget? titleContent;
  final Widget? bottomChild;
  final String backgroundAsset;
  final double heroHeightNarrow;
  final double heroHeightWide;
  final int? backgroundCacheWidth;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final minHeight = isNarrow ? heroHeightNarrow : heroHeightWide;
    final horizontalPadding = isNarrow ? 16.0 : 24.0;
    final topPadding = pageHeaderTopPadding(context);
    final bottomPadding = isNarrow ? 48.0 : 56.0;

    final titleBlock = titleContent ??
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isNarrow ? 20 : 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: DescriptionWithHighlight(
                description: description,
                highlightPhrase: descriptionHighlight,
              ),
            ),
          ],
        );

    if (bottomChild == null && titleContent == null) {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: SizedBox(
          width: double.infinity,
          child: _HeroBackground(
            backgroundAsset: backgroundAsset,
            backgroundCacheWidth: backgroundCacheWidth,
            child: Align(
              alignment: const Alignment(0, 0.12),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  topPadding,
                  horizontalPadding,
                  bottomPadding,
                ),
                child: titleBlock,
              ),
            ),
          ),
        ),
      );
    }

    if (bottomChild == null) {
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: _HeroBackground(
          backgroundAsset: backgroundAsset,
          backgroundCacheWidth: backgroundCacheWidth,
          child: Align(
            alignment: const Alignment(0, 0.12),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                topPadding,
                horizontalPadding,
                bottomPadding,
              ),
              child: titleBlock,
            ),
          ),
        ),
      );
    }

    // Expand vertically to fit spotlight / CTA card (Apps page).
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
        child: _HeroBackground(
          backgroundAsset: backgroundAsset,
          backgroundCacheWidth: backgroundCacheWidth,
          child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            topPadding,
            horizontalPadding,
            bottomPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: titleBlock),
              SizedBox(height: isNarrow ? 32 : 40),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: bottomChild!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroBackground extends StatelessWidget {
  const _HeroBackground({
    required this.child,
    required this.backgroundAsset,
    this.backgroundCacheWidth,
  });

  final Widget child;
  final String backgroundAsset;
  final int? backgroundCacheWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.topCenter,
      children: [
        Positioned.fill(
          child: Image.asset(
            backgroundAsset,
            fit: BoxFit.cover,
            cacheWidth: backgroundCacheWidth,
            errorBuilder: (_, __, ___) => const ColoredBox(color: AppColors.backgroundDark),
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.backgroundDark.withValues(alpha: 0.72),
                  AppColors.backgroundDark.withValues(alpha: 0.88),
                ],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
