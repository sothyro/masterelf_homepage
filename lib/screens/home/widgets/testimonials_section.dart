import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';

/// Placeholder testimonial (from INFORMATION_NEEDED §8.5).
class TestimonialItem {
  const TestimonialItem({
    required this.quote,
    required this.name,
    required this.location,
    this.imagePath,
  });

  final String quote;
  final String name;
  final String location;
  /// Optional image path. If null, falls back to alternating profile/participant.
  final String? imagePath;

  bool get isBlank => quote == '—' && name == '—' && location == '—';
}

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  static final _placeholders = [
    const TestimonialItem(
      quote: 'កូនសិស្ស មានកត្តិយសណាស់ បានចូលរួម កម្មវិធី ម្សិលមិញ 🙏🩵\nសង្ឃឹមថា បានស្គាល់លោកគ្រូ ប្អូន នឹងបាន កែប្រែ វាសនា 🙏',
      name: 'Panha Leakhena',
      location: 'Phnom Penh',
      imagePath: AppContent.assetTestimonialPanhaLeakhena,
    ),
    const TestimonialItem(
      quote: 'អរគុណ លោកគ្រូ សិស្សនៅខាងពេជនិល ទៅចូលរួមកម្មពីធី លោកគ្រូដែលកាលយប់31 អរគុណ លោកគ្រូ 🙏🏻🙏🏻🙏🏻',
      name: 'Moon Pichnil',
      location: 'Preah Sihanouk',
      imagePath: AppContent.assetTestimonialMoon,
    ),
    const TestimonialItem(
      quote: 'សូមគោរពអរគុណលោកគ្រូ ដែលចែកកាដូរពិសេសដល់ទៅពីរមុខក្នុងថ្ងៃជួបជុំ 🙏🙏🙏💙',
      name: 'Sereyrath Aumrith',
      location: 'International',
      imagePath: AppContent.assetTestimonialRithy,
    ),
    const TestimonialItem(
      quote: 'អរគុណលោកគ្រូ បើកមុខឲ្យខ្ញុំលក់ដីដាច់! ខ្ញុំលែងលំបាកហើយ',
      name: 'Sieng Vanna',
      location: 'Kandal',
      imagePath: AppContent.assetTestimonialVanna,
    ),
    const TestimonialItem(
      quote: 'Caishen🙏🙏🙏❤️',
      name: 'Phum Thida',
      location: 'N/A',
      imagePath: AppContent.assetTestimonialThida,
    ),
    const TestimonialItem(
      quote: '🙏🙏🙏❤️Master Elf',
      name: 'Zeii Tey',
      location: 'N/A',
      imagePath: AppContent.assetTestimonialZeiitey,
    ),
    const TestimonialItem(
      quote: 'Yes sure master. អរគុណលោកគ្រូណាស់. Always by my side 🙏🏻🙏🏻🙏🏻. Am so Lucky to know you master is the big gift in my life 🙏🏻🙏🏻🙏🏻🙏🏻💸💰💵🎁🎉',
      name: 'Ya Nara',
      location: 'Takhmao, Cambodia',
      imagePath: AppContent.assetTestimonial7,
    ),
    const TestimonialItem(
      quote: 'ពេលបានអានសំណេរលោកគ្រូរួចធូរចិត្តច្រើន លោកគ្រូពិតជាពូកែខ្លាំងមែនទែន តាមដានតាំងពីដើមដល់ឥឡូវ',
      name: 'Phart Sanit',
      location: 'Siem Reap, Cambodia',
      imagePath: AppContent.assetTestimonial8,
    ),
    const TestimonialItem(
      quote: 'តាមដានគាត់ច្បាស់ៗម៉ង',
      name: 'Ah Pich',
      location: 'Poipet, Cambodia',
      imagePath: AppContent.assetTestimonial9,
    ),
    const TestimonialItem(
      quote: 'អោយតែឃើញផុសលោកគ្រូភាពតានតឹងបាត់អស់អរគុណលោកគ្រូ',
      name: 'Sreylin Khan',
      location: 'Siem Reap, Cambodia',
      imagePath: AppContent.assetTestimonial10,
    ),
    const TestimonialItem(
      quote: 'ចាំតែអានការវិភាគរបស់លោកគ្រូ អានលើកណាក៏ជក់ចិត្តដែរ',
      name: 'Juary Mith',
      location: 'Phnom Penh, Cambodia',
      imagePath: AppContent.assetTestimonial11,
    ),
    const TestimonialItem(
      quote: 'I love you I like to read ពេលលោកគ្រូមិះមានអារម្មណ៍កក់ក្ដៅ',
      name: 'Veth Raksmey',
      location: 'Phnom Penh, Cambodia',
      imagePath: AppContent.assetTestimonial12,
    ),
    const TestimonialItem(
      quote: 'តាមដានលោកគ្រូហុដស៊ុយហើយក្លាយជាការពិតទាំអស់សប្បាយចិត្ត',
      name: 'Taa',
      location: 'Phnom Penh, Cambodia',
      imagePath: AppContent.assetTestimonial13,
    ),
    const TestimonialItem(
      quote: 'តាមដានលោកគ្រូគ្រប់ផុសមិះមិនដែលខុសទេ',
      name: 'Da Na',
      location: 'Phnom Penh, Cambodia',
      imagePath: AppContent.assetTestimonial14,
    ),
    const TestimonialItem(
      quote: 'ខ្ញុំជឿជាក់លើលោកគ្រូ លោកគ្រូមិះក់មិនដែលខុសទេ',
      name: 'Mo Ly',
      location: 'Phnom Penh, Cambodia',
      imagePath: AppContent.assetTestimonial15,
    ),
    const TestimonialItem(
      quote: 'ខ្ញុំតាមដានផុសលោកគ្រូរហូតពិតជាឆុតមែន',
      name: 'Mey In',
      location: 'Siem Reap, Cambodia',
      imagePath: AppContent.assetTestimonial16,
    ),
    const TestimonialItem(
      quote: 'Master Elf និយាយបាន១ថ្ងៃផ្ទុះពេញfb',
      name: 'Chantrea Smile',
      location: 'Tbong khmoum, Cambodia',
      imagePath: AppContent.assetTestimonial17,
    ),
    const TestimonialItem(
      quote: 'Thank you Master, for sharing the most powerful Qi Men Dun Jia strategy.',
      name: 'Suon Mardy',
      location: 'Phnom Penh, Cambodia',
      imagePath: AppContent.assetTestimonial18,
    ),
  ];

  static const double _cardGap = 20;
  /// Fixed card width — preserved across breakpoints; page count grows with window width.
  static const double _cardWidth = 340;
  static const double _cardsHeight = 510;
  static const double _sectionHorizontalPadding = 24;

  /// How many fixed-width cards fit in [availableWidth] (content area minus padding).
  /// Cards never exceed [availableWidth] (mobile may shrink below [_cardWidth]).
  static int _cardsPerPageForAvailableWidth(double availableWidth) {
    final cardW = math.min(_cardWidth, availableWidth);
    final n = ((availableWidth + _cardGap) / (cardW + _cardGap)).floor();
    return math.max(1, n);
  }

  static double _cardWidthForAvailable(double availableWidth) =>
      math.min(_cardWidth, availableWidth);

  static double _cardHeightForAvailable(double availableWidth) =>
      math.min(_cardsHeight, availableWidth * 1.35);

  /// Extra vertical space so hover scale (1.02) is not clipped.
  static const double _cardsVerticalPadding = 24;
  static const Duration _fadeDuration = Duration(milliseconds: 400);
  static const Duration _pageDisplayDuration = Duration(seconds: 6);
  static const Duration _pageTransitionDuration = Duration(milliseconds: 500);

  /// Shuffled copy of [_placeholders] so order is random on each load (desktop and mobile).
  late final List<TestimonialItem> _shuffledItems;

  final PageController _pageController = PageController();
  int _currentPage = 0;
  int? _pageReadyForFlip;
  int _flipScheduleId = 0;
  int? _lastCardsPerPage;
  Timer? _initialRevealTimer;
  Timer? _autoLoopTimer;
  Timer? _fadeAfterTransitionTimer;

  @override
  void initState() {
    super.initState();
    _shuffledItems = List<TestimonialItem>.from(_placeholders)..shuffle(math.Random());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final available = MediaQuery.sizeOf(context).width - 2 * _sectionHorizontalPadding;
      final cardsPerPage = _cardsPerPageForAvailableWidth(available);
      _initialRevealTimer?.cancel();
      _initialRevealTimer = Timer(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() => _pageReadyForFlip = 0);
          _startAutoLoop(cardsPerPage);
        }
      });
    });
  }

  void _scheduleFadeAfterTransition(int page) {
    final id = ++_flipScheduleId;
    _fadeAfterTransitionTimer?.cancel();
    _fadeAfterTransitionTimer = Timer(_pageTransitionDuration, () {
      if (mounted && id == _flipScheduleId) {
        setState(() => _pageReadyForFlip = page);
      }
    });
  }

  void _startAutoLoop(int cardsPerPage) {
    _autoLoopTimer?.cancel();
    _autoLoopTimer = Timer(_pageDisplayDuration, () {
      if (!mounted) return;
      final totalPages = (_shuffledItems.length / cardsPerPage).ceil();
      if (totalPages == 0) return;
      final nextPage = (_currentPage + 1) % totalPages;
      _flipScheduleId++;
      _pageController.animateToPage(
        nextPage,
        duration: _pageTransitionDuration,
        curve: Curves.easeInOut,
      ).then((_) {
        if (mounted) setState(() => _pageReadyForFlip = nextPage);
        _startAutoLoop(cardsPerPage);
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final available = MediaQuery.sizeOf(context).width - 2 * _sectionHorizontalPadding;
    final cardsPerPage = _cardsPerPageForAvailableWidth(available);
    if (_lastCardsPerPage != null && _lastCardsPerPage != cardsPerPage) {
      _currentPage = 0;
      _pageReadyForFlip = null;
      _flipScheduleId++;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _pageReadyForFlip = 0);
        _startAutoLoop(cardsPerPage);
      });
    }
    _lastCardsPerPage = cardsPerPage;
  }

  @override
  void dispose() {
    _initialRevealTimer?.cancel();
    _autoLoopTimer?.cancel();
    _fadeAfterTransitionTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page, int cardsPerPage) {
    final totalPages = (_shuffledItems.length / cardsPerPage).ceil();
    if (totalPages == 0) return;
    final target = ((page % totalPages) + totalPages) % totalPages;
    if (target == _currentPage) return;
    _flipScheduleId++;
    _pageController.animateToPage(
      target,
      duration: _pageTransitionDuration,
      curve: Curves.easeInOut,
    ).then((_) {
      if (mounted) setState(() => _pageReadyForFlip = target);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final availableWidth = width - 2 * _sectionHorizontalPadding;
    final cardsPerPage = _cardsPerPageForAvailableWidth(availableWidth);
    final cardWidth = _cardWidthForAvailable(availableWidth);
    final cardHeight = _cardHeightForAvailable(availableWidth);
    final textTheme = Theme.of(context).textTheme;

    final headingFontSize = isMobile ? 24.0 : 28.0;
    final headingStyle = (textTheme.headlineMedium ?? textTheme.headlineSmall)?.copyWith(
      color: AppColors.onPrimary,
      fontWeight: FontWeight.bold,
      height: 1.15,
      fontSize: headingFontSize,
    );
    final realStyle = highlightStyleForLocale(
      context,
      color: AppColors.accent,
      fontWeight: FontWeight.bold,
      fontSize: isMobile ? 30 : 38,
      height: 1.15,
    );
    final whiteItalicStyle = headingStyle?.copyWith(
      fontStyle: FontStyle.italic,
    );

    final introStyle = textTheme.bodyLarge?.copyWith(
      height: 1.55,
      color: AppColors.onPrimary.withValues(alpha: 0.9),
    );

    final heading = l10n.sectionTestimonialsHeading;
    final headingWidget = RichText(
      text: TextSpan(
        style: headingStyle,
        children: [
          TextSpan(text: l10n.sectionTestimonialsPart1, style: realStyle),
          TextSpan(text: l10n.sectionTestimonialsPart2),
          TextSpan(text: l10n.sectionTestimonialsPart3, style: realStyle),
          TextSpan(text: l10n.sectionTestimonialsPart4, style: whiteItalicStyle),
        ],
      ),
    );

    final headerContent = isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headingWidget,
              const SizedBox(height: 20),
              Text(l10n.sectionTestimonialsSub1, style: introStyle),
              const SizedBox(height: 12),
              Text(l10n.sectionTestimonialsSub2, style: introStyle),
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
                  child: RichText(
                    text: TextSpan(
                      style: headingStyle,
                      children: [
                        TextSpan(text: l10n.sectionTestimonialsPart1, style: realStyle),
                        TextSpan(text: l10n.sectionTestimonialsPart2),
                        TextSpan(text: l10n.sectionTestimonialsPart3, style: realStyle),
                        TextSpan(text: l10n.sectionTestimonialsPart4, style: whiteItalicStyle),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.sectionTestimonialsSub1, style: introStyle),
                    const SizedBox(height: 12),
                    Text(l10n.sectionTestimonialsSub2, style: introStyle),
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 56,
        horizontal: _sectionHorizontalPadding,
      ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerContent,
          const SizedBox(height: 40),
          SizedBox(
            height: cardHeight + 2 * _cardsVerticalPadding,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (p) {
                setState(() => _currentPage = p);
                _scheduleFadeAfterTransition(p);
              },
              itemCount: (_shuffledItems.length / cardsPerPage).ceil(),
              itemBuilder: (context, pageIndex) {
                final start = pageIndex * cardsPerPage;
                final end = math.min(start + cardsPerPage, _shuffledItems.length);
                final count = end - start;
                final isVisible = _pageReadyForFlip != null && pageIndex == _pageReadyForFlip;
                // Full pages: distribute leftover space as gaps so the row spans the viewport.
                // Partial last page: keep the normal gap and pack from the start.
                final useSpaceBetween = count > 1 && count == cardsPerPage;
                return Row(
                  mainAxisAlignment: useSpaceBetween
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = start; i < end; i++) ...[
                      if (!useSpaceBetween && i > start)
                        const SizedBox(width: _cardGap),
                      SizedBox(
                        width: cardWidth,
                        height: cardHeight,
                        child: _FadeTestimonialCard(
                          visible: isVisible,
                          delay: Duration(milliseconds: 50 * (i - start)),
                          duration: _fadeDuration,
                          child: _TestimonialCard(
                            quote: _shuffledItems[i].quote,
                            name: _shuffledItems[i].name,
                            location: _shuffledItems[i].location,
                            imageIndex: i,
                            imagePath: _shuffledItems[i].imagePath,
                            isBlank: _shuffledItems[i].isBlank,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FadeTestimonialCard extends StatefulWidget {
  const _FadeTestimonialCard({
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
      if (mounted) _controller.forward();
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _maybeStartFade();
  }

  @override
  void didUpdateWidget(covariant _FadeTestimonialCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeStartFade();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
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
            border: Border.all(color: AppColors.onPrimary.withValues(alpha: 0.6), width: 1.5),
          ),
          child: Icon(icon, color: AppColors.onPrimary, size: 22),
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatefulWidget {
  const _TestimonialCard({
    required this.quote,
    required this.name,
    required this.location,
    this.imageIndex = 0,
    this.imagePath,
    this.isBlank = false,
  });

  final String quote;
  final String name;
  final String location;
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

  @override
  Widget build(BuildContext context) {
    final shadow = _isHovered ? _cardShadowHover : _cardShadow;
    final borderColor = _isHovered
        ? AppColors.accent
        : AppColors.borderDark;
    final scale = _isHovered ? 1.02 : 1.0;

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
            border: Border.all(color: borderColor, width: _isHovered ? 2 : 1.5),
            boxShadow: shadow,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surfaceElevatedDark,
                AppColors.surfaceElevatedDark,
                Color.lerp(AppColors.surfaceElevatedDark, AppColors.overlayDark, 0.35)!,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Image with subtle bottom gradient and inner shadow
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      widget.imagePath ?? (widget.imageIndex.isEven ? AppContent.assetTestimonialProfile : AppContent.assetTestimonialParticipant),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        child: const Icon(LucideIcons.user, size: 48, color: AppColors.accent),
                      ),
                    ),
                    // Gradient overlay at bottom for depth
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 72,
                      child: Container(
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
              ),
              // Divider line between image and content (theme accent)
              Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
              ),
              // Quote and attribution
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Accent bar with soft glow + quote
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 5,
                            margin: const EdgeInsets.only(right: 12, top: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.5),
                              color: AppColors.accent,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accentGlow.withValues(alpha: 0.7),
                                  blurRadius: 12,
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  color: AppColors.accentGlow.withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  spreadRadius: -2,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              widget.isBlank ? '—' : widget.quote,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                height: 1.55,
                                fontStyle: widget.isBlank ? FontStyle.normal : FontStyle.italic,
                                color: AppColors.onPrimary.withValues(
                                  alpha: widget.isBlank ? 0.4 : 0.92,
                                ),
                                fontSize: 14,
                              ),
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Name with subtle styling
                      Text(
                        widget.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onPrimary.withValues(
                            alpha: widget.isBlank ? 0.5 : 1,
                          ),
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.mapPin,
                            size: 14,
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
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
