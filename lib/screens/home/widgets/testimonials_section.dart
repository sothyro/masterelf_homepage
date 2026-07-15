import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../config/app_content.dart';
import '../../../config/testimonials_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/carousel_row_preloader.dart';
import '../../../utils/breakpoints.dart';
import '../../../utils/mobile_web_performance.dart';
import 'field_work_chinese_design.dart';

const double _testimonialMobileCardAspect = 4 / 5;
const double _testimonialMobileTextSectionHeight = 124;

/// Homepage client-voice carousel with activity-card spacing and Chinese shell.
class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  static const String _preloadOwnerKey = 'home-testimonials';
  static const double _cardGap = 20;
  static const double _cardMaxWidth = 340;
  static const double _cardsHeight = 510;
  static const double _cardsVerticalPadding = 24;
  static const double _stripHorizontalInset = 24;
  static const double _headerMaxWidth = 1100;
  static const Duration _fadeDurationDesktop = Duration(milliseconds: 400);
  static const Duration _fadeDurationMobile = Duration(milliseconds: 250);
  static const Duration _pageDisplayDurationDesktop = Duration(seconds: 6);
  static const Duration _pageDisplayDurationMobile = Duration(seconds: 3);
  static const Duration _pageTransitionDurationDesktop =
      Duration(milliseconds: 500);
  static const Duration _pageTransitionDurationMobile =
      Duration(milliseconds: 280);

  static bool _isMobileWidth(double width) => Breakpoints.isMobile(width);

  static Duration _fadeDurationFor(double width) =>
      _isMobileWidth(width) ? _fadeDurationMobile : _fadeDurationDesktop;

  static Duration _pageDisplayDurationFor(double width) =>
      _isMobileWidth(width)
          ? _pageDisplayDurationMobile
          : _pageDisplayDurationDesktop;

  static Duration _pageTransitionDurationFor(double width) =>
      _isMobileWidth(width)
          ? _pageTransitionDurationMobile
          : _pageTransitionDurationDesktop;

  late final List<TestimonialItem> _shuffledItems;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int? _pageReadyForFlip;
  int _flipScheduleId = 0;
  int? _cardsPerPageSnapshot;
  bool _inViewport = false;
  int _autoLoopGeneration = 0;

  @override
  void initState() {
    super.initState();
    _shuffledItems = List<TestimonialItem>.from(buildCuratedTestimonials())
      ..shuffle(math.Random());
  }

  static double _cardHeightForWidth(double viewportWidth) {
    if (!Breakpoints.isMobile(viewportWidth)) return _cardsHeight;
    final cardWidth = viewportWidth - _stripHorizontalInset * 2;
    final imageHeight = cardWidth / _testimonialMobileCardAspect;
    return imageHeight + _testimonialMobileTextSectionHeight + 2;
  }

  static int _cardsPerPageForWidth(double viewportWidth) {
    if (Breakpoints.isMobile(viewportWidth)) return 1;
    final innerWidth = viewportWidth - _stripHorizontalInset * 2;
    return math.max(
      1,
      ((innerWidth + _cardGap) / (_cardMaxWidth + _cardGap)).floor(),
    );
  }

  static double _cardLayoutWidthFor(double viewportWidth) {
    if (Breakpoints.isMobile(viewportWidth)) {
      return viewportWidth - _stripHorizontalInset * 2;
    }
    return _cardMaxWidth;
  }

  final List<String> _rowPathsBuffer = [];

  void _portraitPathsForPage(int page, int cardsPerPage, List<String> out) {
    out.clear();
    final start = page * cardsPerPage;
    final end = math.min(start + cardsPerPage, _shuffledItems.length);
    for (var i = start; i < end; i++) {
      final path = _shuffledItems[i].imagePath;
      if (path != null) out.add(path);
    }
  }

  void _preloadCurrentRow() {
    final width = MediaQuery.sizeOf(context).width;
    final cardsPerPage = _cardsPerPageForWidth(width);
    _portraitPathsForPage(_currentPage, cardsPerPage, _rowPathsBuffer);
    unawaited(
      CarouselRowPreloader.preloadRow(
        ownerKey: _preloadOwnerKey,
        paths: _rowPathsBuffer,
        cardsPerPage: cardsPerPage,
        mobileSequential: Breakpoints.isMobile(width),
      ),
    );
  }

  void _prefetchNextRow() {
    final width = MediaQuery.sizeOf(context).width;
    final cardsPerPage = _cardsPerPageForWidth(width);
    final totalPages = (_shuffledItems.length / cardsPerPage).ceil();
    if (totalPages == 0) return;
    final nextPage = (_currentPage + 1) % totalPages;
    _portraitPathsForPage(nextPage, cardsPerPage, _rowPathsBuffer);
    unawaited(
      CarouselRowPreloader.preloadRow(
        ownerKey: _preloadOwnerKey,
        paths: _rowPathsBuffer,
        cardsPerPage: cardsPerPage,
        mobileSequential: Breakpoints.isMobile(width),
      ),
    );
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    final visible = info.visibleFraction > 0;
    if (visible == _inViewport) return;
    _inViewport = visible;
    if (visible) {
      if (_pageReadyForFlip == null && mounted) {
        setState(() => _pageReadyForFlip = 0);
      }
      _preloadCurrentRow();
      _startAutoLoop();
    } else {
      _autoLoopGeneration++;
      CarouselRowPreloader.cancel(_preloadOwnerKey);
    }
  }

  void _scheduleFadeAfterTransition(int page) {
    final id = ++_flipScheduleId;
    final transition =
        _pageTransitionDurationFor(MediaQuery.sizeOf(context).width);
    Future<void>.delayed(transition, () {
      if (mounted && id == _flipScheduleId) {
        setState(() => _pageReadyForFlip = page);
      }
    });
  }

  void _startAutoLoop() {
    if (MobileWebPerformance.prefersReducedMotion(context)) return;
    final generation = _autoLoopGeneration;
    final width = MediaQuery.sizeOf(context).width;
    final displayDuration = _pageDisplayDurationFor(width);
    final transitionDuration = _pageTransitionDurationFor(width);
    _prefetchNextRow();
    Future<void>.delayed(displayDuration, () {
      if (!mounted || !_inViewport || generation != _autoLoopGeneration) return;
      final cardsPerPage = _cardsPerPageForWidth(width);
      final totalPages = (_shuffledItems.length / cardsPerPage).ceil();
      if (totalPages == 0) return;
      final nextPage = (_currentPage + 1) % totalPages;
      _flipScheduleId++;
      _pageController
          .animateToPage(
            nextPage,
            duration: transitionDuration,
            curve: Curves.easeInOut,
          )
          .then((_) {
        if (mounted && _inViewport && generation == _autoLoopGeneration) {
          _startAutoLoop();
        }
      });
    });
  }

  @override
  void dispose() {
    _autoLoopGeneration++;
    CarouselRowPreloader.cancel(_preloadOwnerKey);
    VisibilityDetectorController.instance.forget(
      const ValueKey<String>('testimonials-section'),
    );
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final isCompact = Breakpoints.isCompact(width);
    final cardsPerPage = _cardsPerPageForWidth(width);

    if (_cardsPerPageSnapshot != null &&
        _cardsPerPageSnapshot != cardsPerPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_pageController.hasClients) return;
        _flipScheduleId++;
        _pageController.jumpToPage(0);
        setState(() {
          _currentPage = 0;
          _pageReadyForFlip = 0;
        });
      });
    }
    _cardsPerPageSnapshot = cardsPerPage;

    return VisibilityDetector(
      key: const ValueKey<String>('testimonials-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(child: ChineseInkWashGlow()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _stripHorizontalInset,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: _headerMaxWidth),
                      child: Column(
                        children: [
                          FieldWorkChineseSectionHeader(
                            title: l10n.homeTestimonialsHeading,
                            headline: l10n.homeTestimonialsSub1,
                            isMobile: isMobile || isCompact,
                            centerEmblem: TestimonialVoiceSeal(
                              size: isMobile || isCompact ? 36 : 44,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: _cardHeightForWidth(width) +
                      2 * _cardsVerticalPadding +
                      (isMobile ? 12 : 0),
                  width: double.infinity,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() => _currentPage = page);
                      _scheduleFadeAfterTransition(page);
                      _preloadCurrentRow();
                    },
                    itemCount: (_shuffledItems.length / cardsPerPage).ceil(),
                    itemBuilder: (context, pageIndex) {
                      final start = pageIndex * cardsPerPage;
                      final end = math.min(
                        start + cardsPerPage,
                        _shuffledItems.length,
                      );
                      final isVisible = _pageReadyForFlip != null &&
                          pageIndex == _pageReadyForFlip;
                      return _buildCarouselPage(
                        pageIndex: pageIndex,
                        start: start,
                        end: end,
                        isVisible: isVisible,
                        isMobile: isMobile,
                        viewportWidth: width,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselPage({
    required int pageIndex,
    required int start,
    required int end,
    required bool isVisible,
    required bool isMobile,
    required double viewportWidth,
  }) {
    final cardWidth =
        isMobile ? viewportWidth - _stripHorizontalInset * 2 : _cardMaxWidth;
    final cardHeight = _cardHeightForWidth(viewportWidth);

    Widget buildCard(int itemIndex, int slotIndex) {
      final item = _shuffledItems[itemIndex];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: _cardsVerticalPadding),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = isMobile ? constraints.maxWidth : cardWidth;
            return SizedBox(
              width: width,
              height: cardHeight,
              child: _FadeTestimonialCard(
                key: ValueKey<String>('fade-$pageIndex-$itemIndex'),
                visible: isVisible,
                delay: Duration(milliseconds: 50 * slotIndex),
                duration: _fadeDurationFor(viewportWidth),
                child: _TestimonialCard(
                  quote: item.quote,
                  name: item.name,
                  location: item.location,
                  imageIndex: itemIndex,
                  imagePath: item.imagePath,
                  imageTopInset: item.imageTopInset,
                  isBlank: item.isBlank,
                  isMobile: isMobile,
                ),
              ),
            );
          },
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _stripHorizontalInset),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = start; i < end; i++) ...[
              if (i > start) const SizedBox(width: _cardGap),
              if (isMobile)
                Expanded(child: buildCard(i, i - start))
              else
                buildCard(i, i - start),
            ],
          ],
        ),
      ),
    );
  }
}

class _FadeTestimonialCard extends StatefulWidget {
  const _FadeTestimonialCard({
    super.key,
    required this.child,
    required this.visible,
    required this.delay,
    required this.duration,
  });

  final Widget child;
  final bool visible;
  final Duration delay;
  final Duration duration;

  @override
  State<_FadeTestimonialCard> createState() => _FadeTestimonialCardState();
}

class _FadeTestimonialCardState extends State<_FadeTestimonialCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasStarted = false;

  void _maybeStartFade() {
    if (!widget.visible || _hasStarted || !mounted) return;
    _hasStarted = true;
    Future<void>.delayed(widget.delay, () {
      if (mounted && widget.visible) _controller.forward();
    });
  }

  void _resetFade() {
    _hasStarted = false;
    _controller.reset();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _maybeStartFade();
  }

  @override
  void didUpdateWidget(covariant _FadeTestimonialCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.visible && oldWidget.visible) {
      _resetFade();
    } else if (widget.visible && !oldWidget.visible) {
      _resetFade();
      _maybeStartFade();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}

class _TestimonialNameBadge extends StatelessWidget {
  const _TestimonialNameBadge({
    required this.name,
    this.compact = false,
    this.isBlank = false,
  });

  final String name;
  final bool compact;
  final bool isBlank;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.accent;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.user,
            size: compact ? 12 : 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              isBlank ? '—' : name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: compact ? 11 : 12,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatefulWidget {
  const _TestimonialCard({
    required this.quote,
    required this.name,
    required this.location,
    required this.isMobile,
    this.imageTopInset = 0,
    this.imageIndex = 0,
    this.imagePath,
    this.isBlank = false,
  });

  final String quote;
  final String name;
  final String location;
  final bool isMobile;
  final double imageTopInset;
  final int imageIndex;
  final String? imagePath;
  final bool isBlank;

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard> {
  bool _isHovered = false;

  static final List<BoxShadow> _cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.5),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 20,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> _cardShadowHover = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.55),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: AppColors.accentGlow.withValues(alpha: 0.35),
      blurRadius: 12,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 16,
      offset: const Offset(0, 1),
    ),
  ];

  String get _resolvedImagePath =>
      widget.imagePath ??
      (widget.imageIndex.isEven
          ? AppContent.assetTestimonialProfile
          : AppContent.assetTestimonialParticipant);

  @override
  Widget build(BuildContext context) {
    final shadow = _isHovered ? _cardShadowHover : _cardShadow;
    final borderColor =
        _isHovered ? AppColors.accent : AppColors.borderDark;
    final scale = widget.isMobile ? 1.0 : (_isHovered ? 1.02 : 1.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: borderColor,
              width: _isHovered ? 2 : 1.5,
            ),
            boxShadow: shadow,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surfaceElevatedDark,
                AppColors.surfaceElevatedDark,
                Color.lerp(
                  AppColors.surfaceElevatedDark,
                  AppColors.overlayDark,
                  0.35,
                )!,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: widget.isMobile
              ? Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AspectRatio(
                        aspectRatio: _testimonialMobileCardAspect,
                        child: _buildImageBlock(),
                      ),
                      _buildDivider(),
                      _buildTextBlock(),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: _buildImageBlock(),
                    ),
                    _buildDivider(),
                    Expanded(child: _buildTextBlock()),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildImageBlock() {
    const imageFit = BoxFit.cover;
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final cardLayoutWidth = widget.isMobile
        ? viewportWidth - 48
        : 340.0;
    final topInset = widget.imageTopInset;

    final image = Image.asset(
      _resolvedImagePath,
      fit: imageFit,
      alignment: topInset > 0 ? Alignment.topCenter : Alignment.center,
      cacheWidth: MobileWebPerformance.cardImageCacheWidth(
        context,
        cardLayoutWidth,
      ),
      filterQuality: MobileWebPerformance.imageFilterQuality(context),
      errorBuilder: (_, __, ___) => ColoredBox(
        color: AppColors.accent.withValues(alpha: 0.15),
        child: const Icon(
          LucideIcons.user,
          size: 48,
          color: AppColors.accent,
        ),
      ),
    );

    return ColoredBox(
      color: AppColors.borderDark.withValues(alpha: 0.35),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (topInset > 0)
            Positioned(
              top: topInset,
              left: 0,
              right: 0,
              bottom: 0,
              child: image,
            )
          else
            Positioned.fill(child: image),
          if (!widget.isMobile)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 72,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 2,
      margin: EdgeInsets.symmetric(horizontal: widget.isMobile ? 12 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            AppColors.accent.withValues(alpha: 0.6),
            AppColors.accent.withValues(alpha: 0.85),
            AppColors.accent.withValues(alpha: 0.6),
            Colors.transparent,
          ],
          stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
    );
  }

  Widget _buildTextBlock() {
    final quoteStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          height: widget.isMobile ? 1.35 : 1.45,
          fontStyle: widget.isBlank ? FontStyle.normal : FontStyle.italic,
          color: AppColors.onPrimary.withValues(
            alpha: widget.isBlank ? 0.4 : 0.82,
          ),
          fontSize: widget.isMobile ? 13 : 14,
        );

    return Padding(
      padding: widget.isMobile
          ? const EdgeInsets.fromLTRB(14, 8, 14, 6)
          : const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: widget.isMobile ? MainAxisSize.min : MainAxisSize.max,
        children: [
          _TestimonialNameBadge(
            name: widget.name,
            compact: widget.isMobile,
            isBlank: widget.isBlank,
          ),
          SizedBox(height: widget.isMobile ? 6 : 10),
          if (widget.isMobile)
            Text(
              widget.isBlank ? '—' : widget.quote,
              style: quoteStyle,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            )
          else
            Expanded(
              child: Text(
                widget.isBlank ? '—' : widget.quote,
                style: quoteStyle,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          SizedBox(height: widget.isMobile ? 4 : 8),
          Row(
            children: [
              Icon(
                LucideIcons.mapPin,
                size: widget.isMobile ? 12 : 14,
                color: AppColors.accent.withValues(
                  alpha: widget.isBlank ? 0.4 : 0.9,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.location,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onPrimary.withValues(
                          alpha: widget.isBlank ? 0.45 : 0.7,
                        ),
                        fontSize: widget.isMobile ? 11 : 12,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
