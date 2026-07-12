import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../config/book_store_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../utils/mobile_web_performance.dart';

/// Homepage 5-Blessing book showcase (under Academies) — portrait 4:5 cards.
class PublicationsStrip extends StatelessWidget {
  const PublicationsStrip({super.key});

  static const double _cardGap = 16;
  static const double _scrollCardWidth = 200;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final isTabletScroll = Breakpoints.isTabletOnly(width);
    final books = buildHomeBookShowcase(l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.homePublicationsHeading,
          style: highlightStyleForLocale(
            context,
            fontSize: isMobile ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.homePublicationsSubline,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFFB0B0B0),
                height: 1.45,
              ),
        ),
        const SizedBox(height: 24),
        if (isMobile)
          _BooksMobileCarousel(books: books)
        else if (isTabletScroll)
          _BooksShowcaseScroller(
            books: books,
            cardWidth: _scrollCardWidth,
          )
        else
          _BooksShowcaseRow(books: books),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.center,
          child: FilledButton.icon(
            onPressed: () => context.push('/books'),
            icon: const Icon(LucideIcons.arrowRight, size: 18),
            label: Text(
              l10n.homePublicationsViewAll,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 0.2,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.onAccent,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BooksMobileCarousel extends StatefulWidget {
  const _BooksMobileCarousel({required this.books});

  final List<HomeBookShowcaseItem> books;

  @override
  State<_BooksMobileCarousel> createState() => _BooksMobileCarouselState();
}

class _BooksMobileCarouselState extends State<_BooksMobileCarousel> {
  static const _cycleDurationDesktop = Duration(seconds: 2);
  static const _cycleDurationMobileWeb = Duration(seconds: 4);
  static const _transitionDuration = Duration(milliseconds: 400);

  int _index = 0;
  Timer? _timer;
  bool _inViewport = false;

  @override
  void initState() {
    super.initState();
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.books.length <= 1 || !mounted) return;
    final cycle = MobileWebPerformance.isMobileWeb(context)
        ? _cycleDurationMobileWeb
        : _cycleDurationDesktop;
    _timer = Timer.periodic(cycle, (_) {
      if (!mounted || !_inViewport) return;
      setState(() => _index = (_index + 1) % widget.books.length);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    final visible = info.visibleFraction > 0;
    if (visible == _inViewport) return;
    _inViewport = visible;
    if (visible) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  @override
  void dispose() {
    _stopTimer();
    VisibilityDetectorController.instance.forget(
      const ValueKey<String>('books-mobile-carousel'),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.books.isEmpty) return const SizedBox.shrink();

    final width = MediaQuery.sizeOf(context).width;
    final cardWidth = width - 32;
    final book = widget.books[_index];
    final carouselHeight =
        cardWidth * (5 / 4) + _PortraitBookCard.textBlockHeight + 44;

    return VisibilityDetector(
      key: const ValueKey<String>('books-mobile-carousel'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Column(
      children: [
        SizedBox(
          height: carouselHeight,
          child: AnimatedSwitcher(
            duration: _transitionDuration,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.04, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: SizedBox(
              key: ValueKey(book.id),
              width: cardWidth,
              child: _PortraitBookCard(
                item: book,
                onTap: () => context.push(bookStoreRouteForId(book.id)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.books.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == _index ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: i == _index
                      ? AppColors.accent
                      : AppColors.accent.withValues(alpha: 0.28),
                ),
              ),
          ],
        ),
      ],
    ),
    );
  }
}

class _BooksShowcaseRow extends StatelessWidget {
  const _BooksShowcaseRow({required this.books});

  final List<HomeBookShowcaseItem> books;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < books.length; i++) ...[
              if (i > 0) const SizedBox(width: PublicationsStrip._cardGap),
              Expanded(
                child: _PortraitBookCard(
                  item: books[i],
                  stretch: true,
                  onTap: () => context.push(bookStoreRouteForId(books[i].id)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BooksShowcaseScroller extends StatelessWidget {
  const _BooksShowcaseScroller({
    required this.books,
    required this.cardWidth,
  });

  final List<HomeBookShowcaseItem> books;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cardWidth * (5 / 4) + _PortraitBookCard.textBlockHeight + 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
        itemCount: books.length,
        separatorBuilder: (_, __) => const SizedBox(width: PublicationsStrip._cardGap),
        itemBuilder: (context, index) {
          return SizedBox(
            width: cardWidth,
            child: _PortraitBookCard(
              item: books[index],
              onTap: () => context.push(bookStoreRouteForId(books[index].id)),
            ),
          );
        },
      ),
    );
  }
}

class _PortraitBookCard extends StatefulWidget {
  const _PortraitBookCard({
    required this.item,
    required this.onTap,
    this.stretch = false,
  });

  final HomeBookShowcaseItem item;
  final VoidCallback onTap;
  final bool stretch;

  static const double _titleBlockHeight = 50;
  static const double _subtitleBlockHeight = 54;
  static const double textBlockHeight = _titleBlockHeight + 6 + _subtitleBlockHeight + 16;

  @override
  State<_PortraitBookCard> createState() => _PortraitBookCardState();
}

class _PortraitBookCardState extends State<_PortraitBookCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final cardWidth = MediaQuery.sizeOf(context).width;

    final textBlock = Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: _PortraitBookCard._titleBlockHeight,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                item.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: const Color(0xFFE8E8E8),
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      letterSpacing: 0.2,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: _PortraitBookCard._subtitleBlockHeight,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                item.subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFB0B0B0),
                      height: 1.35,
                    ),
              ),
            ),
          ),
        ],
      ),
    );

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      height: widget.stretch ? double.infinity : null,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _hovered
              ? AppColors.accent.withValues(alpha: 0.75)
              : AppColors.borderDark,
          width: _hovered ? 1.5 : 1,
        ),
        boxShadow: _hovered ? AppShadows.cardHover : AppShadows.card,
      ),
      clipBehavior: Clip.none,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12.5)),
                child: AspectRatio(
                  aspectRatio: 4 / 5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        item.coverAsset,
                        fit: BoxFit.cover,
                        cacheWidth: MobileWebPerformance.devicePixelCacheWidth(
                          context,
                          cardWidth,
                        ),
                        filterQuality: MobileWebPerformance.imageFilterQuality(context),
                        errorBuilder: (_, __, ___) => ColoredBox(
                          color: AppColors.borderDark,
                          child: Icon(
                            LucideIcons.bookOpen,
                            color: AppColors.accent.withValues(alpha: 0.5),
                            size: 40,
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.12),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.accent.withValues(alpha: 0.5),
                      AppColors.accent.withValues(alpha: 0.85),
                      AppColors.accent.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                  ),
                ),
              ),
              if (widget.stretch) Expanded(child: textBlock) else textBlock,
            ],
          ),
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: card,
    );
  }
}
