import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../config/field_work_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/carousel_row_preloader.dart';
import '../../../utils/breakpoints.dart';
import '../../../utils/mobile_web_performance.dart';
import '../field_work_widgets.dart';

const double _activityMobileCardAspect = 4 / 5;
const double _activityMobileTextSectionHeight = 96;

/// Core activity cards in a full-width carousel (same behaviour as testimonials).
class ActivityStoriesSection extends StatefulWidget {
  const ActivityStoriesSection({
    super.key,
    required this.l10n,
    required this.pillars,
    this.heading,
    this.subline,
    this.initialRealm,
    this.preloadOwnerKey = 'activity-stories-section',
  });

  final AppLocalizations l10n;
  final List<FieldWorkShowcasePillar> pillars;
  final String? heading;
  final String? subline;
  final FieldWorkRealm? initialRealm;
  final String preloadOwnerKey;

  @override
  State<ActivityStoriesSection> createState() => _ActivityStoriesSectionState();
}

class _ActivityStoriesSectionState extends State<ActivityStoriesSection> {
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
  static const Duration _pageTransitionDurationDesktop = Duration(milliseconds: 500);
  static const Duration _pageTransitionDurationMobile = Duration(milliseconds: 280);

  static bool _isMobileWidth(double width) => Breakpoints.isMobile(width);

  static Duration _fadeDurationFor(double width) =>
      _isMobileWidth(width) ? _fadeDurationMobile : _fadeDurationDesktop;

  static Duration _pageDisplayDurationFor(double width) =>
      _isMobileWidth(width) ? _pageDisplayDurationMobile : _pageDisplayDurationDesktop;

  static Duration _pageTransitionDurationFor(double width) =>
      _isMobileWidth(width)
          ? _pageTransitionDurationMobile
          : _pageTransitionDurationDesktop;

  late final List<FieldWorkShowcasePillar> _shuffledPillars;
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
    _shuffledPillars = List<FieldWorkShowcasePillar>.from(widget.pillars);
    final realm = widget.initialRealm;
    if (realm != null) {
      _shuffledPillars.sort((a, b) {
        final aMatch = a.realm == realm;
        final bMatch = b.realm == realm;
        if (aMatch == bMatch) return 0;
        return aMatch ? -1 : 1;
      });
    }
  }

  static double _cardHeightForWidth(double viewportWidth) {
    if (!Breakpoints.isMobile(viewportWidth)) return _cardsHeight;
    final cardWidth = viewportWidth - _stripHorizontalInset * 2;
    final imageHeight = cardWidth / _activityMobileCardAspect;
    return imageHeight + _activityMobileTextSectionHeight + 2;
  }

  static int _cardsPerPageForWidth(double viewportWidth) {
    if (Breakpoints.isMobile(viewportWidth)) return 1;
    final innerWidth = viewportWidth - _stripHorizontalInset * 2;
    return math.max(
      1,
      ((innerWidth + _cardGap) / (_cardMaxWidth + _cardGap)).floor(),
    );
  }

  void _coverPathsForPage(int page, int cardsPerPage, List<String> out) {
    out.clear();
    final start = page * cardsPerPage;
    final end = math.min(start + cardsPerPage, _shuffledPillars.length);
    for (var i = start; i < end; i++) {
      out.add(_shuffledPillars[i].coverImage);
    }
  }

  final List<String> _rowPathsBuffer = [];

  void _preloadCurrentRow() {
    final width = MediaQuery.sizeOf(context).width;
    final cardsPerPage = _cardsPerPageForWidth(width);
    _coverPathsForPage(_currentPage, cardsPerPage, _rowPathsBuffer);
    unawaited(
      CarouselRowPreloader.preloadRow(
        ownerKey: widget.preloadOwnerKey,
        paths: _rowPathsBuffer,
        cardsPerPage: cardsPerPage,
        mobileSequential: Breakpoints.isMobile(width),
      ),
    );
  }

  void _prefetchNextRow() {
    final width = MediaQuery.sizeOf(context).width;
    final cardsPerPage = _cardsPerPageForWidth(width);
    final totalPages = (_shuffledPillars.length / cardsPerPage).ceil();
    if (totalPages == 0) return;
    final nextPage = (_currentPage + 1) % totalPages;
    _coverPathsForPage(nextPage, cardsPerPage, _rowPathsBuffer);
    unawaited(
      CarouselRowPreloader.preloadRow(
        ownerKey: widget.preloadOwnerKey,
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
      CarouselRowPreloader.cancel(widget.preloadOwnerKey);
    }
  }

  void _scheduleFadeAfterTransition(int page) {
    final id = ++_flipScheduleId;
    final transition = _pageTransitionDurationFor(MediaQuery.sizeOf(context).width);
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
      final totalPages = (_shuffledPillars.length / cardsPerPage).ceil();
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

  void _goToPage(int page, int cardsPerPage) {
    final totalPages = (_shuffledPillars.length / cardsPerPage).ceil();
    if (totalPages == 0) return;
    final target = ((page % totalPages) + totalPages) % totalPages;
    if (target == _currentPage) return;
    _flipScheduleId++;
    _pageController.animateToPage(
      target,
      duration: _pageTransitionDurationFor(MediaQuery.sizeOf(context).width),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _autoLoopGeneration++;
    CarouselRowPreloader.cancel(widget.preloadOwnerKey);
    VisibilityDetectorController.instance.forget(
      const ValueKey<String>('activity-stories-section'),
    );
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final cardsPerPage = _cardsPerPageForWidth(width);

    if (_cardsPerPageSnapshot != null && _cardsPerPageSnapshot != cardsPerPage) {
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

    final headingStyle = highlightStyleForLocale(
      context,
      fontSize: isMobile ? 24 : 30,
      fontWeight: FontWeight.bold,
      color: AppColors.accent,
    );
    final introStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColors.onPrimary.withValues(alpha: 0.9),
          height: 1.45,
        );

    final sectionHeading = widget.heading ?? l10n.fieldWorkStoriesHeading;
    final sectionSubline = widget.subline ?? l10n.fieldWorkStoriesSubline;

    final headerContent = isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sectionHeading, style: headingStyle),
              const SizedBox(height: 12),
              Text(sectionSubline, style: introStyle),
              const SizedBox(height: 24),
              Row(
                children: [
                  _NavButton(
                    icon: LucideIcons.chevronLeft,
                    onPressed: () => _goToPage(_currentPage - 1, cardsPerPage),
                  ),
                  const SizedBox(width: 12),
                  _NavButton(
                    icon: LucideIcons.chevronRight,
                    onPressed: () => _goToPage(_currentPage + 1, cardsPerPage),
                  ),
                ],
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Text(sectionHeading, style: headingStyle),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sectionSubline, style: introStyle),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _NavButton(
                          icon: LucideIcons.chevronLeft,
                          onPressed: () => _goToPage(_currentPage - 1, cardsPerPage),
                        ),
                        const SizedBox(width: 12),
                        _NavButton(
                          icon: LucideIcons.chevronRight,
                          onPressed: () => _goToPage(_currentPage + 1, cardsPerPage),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );

    return VisibilityDetector(
      key: const ValueKey<String>('activity-stories-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 56),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF24201A),
              Color(0xFF161210),
              Color(0xFF0A0808),
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _stripHorizontalInset),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _headerMaxWidth),
                  child: headerContent,
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
                  _preloadCurrentRow();
                  _scheduleFadeAfterTransition(page);
                },
                itemCount: (_shuffledPillars.length / cardsPerPage).ceil(),
                itemBuilder: (context, pageIndex) {
                  final start = pageIndex * cardsPerPage;
                  final end = math.min(start + cardsPerPage, _shuffledPillars.length);
                  final isVisible =
                      _pageReadyForFlip != null && pageIndex == _pageReadyForFlip;
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
    final cardWidth = isMobile
        ? viewportWidth - _stripHorizontalInset * 2
        : _cardMaxWidth;
    final cardHeight = _cardHeightForWidth(viewportWidth);

    Widget buildCard(int itemIndex, int slotIndex) {
      final pillar = _shuffledPillars[itemIndex];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: _cardsVerticalPadding),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = isMobile ? constraints.maxWidth : cardWidth;
            return SizedBox(
              width: width,
              height: cardHeight,
              child: _FadeActivityCard(
                key: ValueKey<String>('fade-$pageIndex-$itemIndex'),
                visible: isVisible,
                delay: Duration(milliseconds: 50 * slotIndex),
                duration: _fadeDurationFor(viewportWidth),
                child: _ActivityStoryCard(
                  pillar: pillar,
                  l10n: widget.l10n,
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

class _FadeActivityCard extends StatefulWidget {
  const _FadeActivityCard({
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
  State<_FadeActivityCard> createState() => _FadeActivityCardState();
}

class _FadeActivityCardState extends State<_FadeActivityCard>
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
  void didUpdateWidget(covariant _FadeActivityCard oldWidget) {
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

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.onPrimary.withValues(alpha: 0.6),
              width: 1.5,
            ),
          ),
          child: Icon(icon, color: AppColors.onPrimary, size: 22),
        ),
      ),
    );
  }
}

class _ActivityStoryCard extends StatefulWidget {
  const _ActivityStoryCard({
    required this.pillar,
    required this.l10n,
    required this.isMobile,
  });

  final FieldWorkShowcasePillar pillar;
  final AppLocalizations l10n;
  final bool isMobile;

  @override
  State<_ActivityStoryCard> createState() => _ActivityStoryCardState();
}

class _ActivityStoryCardState extends State<_ActivityStoryCard> {
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

  @override
  Widget build(BuildContext context) {
    final pillar = widget.pillar;
    final realm = pillar.realm;
    final languageCode = Localizations.localeOf(context).languageCode;
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push(pillar.linkPath),
            borderRadius: BorderRadius.circular(18),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: borderColor, width: _isHovered ? 2 : 1.5),
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
                            aspectRatio: _activityMobileCardAspect,
                            child: _buildImageBlock(pillar),
                          ),
                          _buildDivider(),
                          _buildTextBlock(pillar, realm, languageCode),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: _buildImageBlock(pillar),
                        ),
                        _buildDivider(),
                        Expanded(child: _buildTextBlock(pillar, realm, languageCode)),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageBlock(FieldWorkShowcasePillar pillar) {
    final imageFit = widget.isMobile ? BoxFit.contain : BoxFit.cover;
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final cardLayoutWidth = widget.isMobile
        ? viewportWidth - 48
        : 340.0;

    return ColoredBox(
      color: AppColors.borderDark.withValues(alpha: 0.35),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            pillar.coverImage,
            fit: imageFit,
            alignment: Alignment.center,
            cacheWidth: MobileWebPerformance.cardImageCacheWidth(
              context,
              cardLayoutWidth,
            ),
            filterQuality: MobileWebPerformance.imageFilterQuality(context),
            errorBuilder: (_, __, ___) => ColoredBox(
              color: AppColors.borderDark,
              child: Icon(
                pillar.icon,
                color: pillar.accentColor,
                size: 48,
              ),
            ),
          ),
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

  Widget _buildTextBlock(
    FieldWorkShowcasePillar pillar,
    FieldWorkRealm realm,
    String languageCode,
  ) {
    return Padding(
      padding: widget.isMobile
          ? const EdgeInsets.fromLTRB(14, 8, 14, 6)
          : const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: widget.isMobile ? MainAxisSize.min : MainAxisSize.max,
        children: [
          FieldWorkRealmBadge(
            realm: realm,
            l10n: widget.l10n,
            compact: widget.isMobile,
          ),
          SizedBox(height: widget.isMobile ? 6 : 12),
          Text(
            pillar.localizedTitle(languageCode),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onPrimary,
                  height: 1.25,
                  fontSize: widget.isMobile ? 14 : null,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: widget.isMobile ? 4 : 8),
          if (widget.isMobile)
            Text(
              pillar.localizedSubtitle(languageCode),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.82),
                    height: 1.35,
                    fontSize: 13,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            )
          else
            Expanded(
              child: Text(
                pillar.localizedSubtitle(languageCode),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.82),
                      height: 1.45,
                    ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
