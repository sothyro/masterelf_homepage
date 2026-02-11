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
    // 9 blank cards for future testimonials
    ...List.generate(9, (_) => const TestimonialItem(quote: '—', name: '—', location: '—')),
  ];

  static const int _cardsPerPage = 5;
  static const double _cardWidth = 260;
  static const double _cardGap = 16;
  static const double _cardsHeight = 380;
  static const Duration _flipStaggerDelay = Duration(milliseconds: 120);
  static const Duration _flipDuration = Duration(milliseconds: 450);
  static const Duration _pageDisplayDuration = Duration(seconds: 6);
  static const Duration _pageTransitionDuration = Duration(milliseconds: 800);

  final PageController _pageController = PageController();
  int _currentPage = 0;
  int? _pageReadyForFlip;
  int _flipScheduleId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Future<void>.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _pageReadyForFlip = 0);
      });
    });
    _startAutoLoop();
  }

  void _scheduleFlipAfterTransition(int page) {
    final id = ++_flipScheduleId;
    Future<void>.delayed(_pageTransitionDuration, () {
      if (mounted && id == _flipScheduleId) {
        setState(() => _pageReadyForFlip = page);
      }
    });
  }

  void _startAutoLoop() {
    Future<void>.delayed(_pageDisplayDuration, () {
      if (!mounted) return;
      final totalPages = (_placeholders.length / _cardsPerPage).ceil();
      final nextPage = (_currentPage + 1) % totalPages;
      _flipScheduleId++;
      _pageController.animateToPage(
        nextPage,
        duration: _pageTransitionDuration,
        curve: Curves.easeInOut,
      ).then((_) {
        if (mounted) setState(() => _pageReadyForFlip = nextPage);
        _startAutoLoop();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    final totalPages = (_placeholders.length / _cardsPerPage).ceil();
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
    final textTheme = Theme.of(context).textTheme;

    final headingFontSize = isMobile ? 24.0 : 28.0;
    final headingStyle = (textTheme.headlineMedium ?? textTheme.headlineSmall)?.copyWith(
      color: AppColors.onPrimary,
      fontWeight: FontWeight.bold,
      height: 1.15,
      fontSize: headingFontSize,
    );
    final realStyle = GoogleFonts.condiment(
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
    final hasRealInsightsOutcomes = heading.contains('Real') && heading.contains('Insights') && heading.contains('Outcomes');
    final headingWidget = hasRealInsightsOutcomes
        ? RichText(
            text: TextSpan(
              style: headingStyle,
              children: [
                TextSpan(text: 'Real ', style: realStyle),
                TextSpan(text: 'Insights.\n'),
                TextSpan(text: 'Real ', style: realStyle),
                TextSpan(text: 'Outcomes.', style: whiteItalicStyle),
              ],
            ),
          )
        : Text(heading, style: headingStyle);

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
                    onPressed: () => _goToPage(_currentPage - 1),
                  ),
                  const SizedBox(width: 12),
                  _NavButton(
                    icon: LucideIcons.chevronRight,
                    onPressed: () => _goToPage(_currentPage + 1),
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
                  child: hasRealInsightsOutcomes
                      ? RichText(
                          text: TextSpan(
                            style: headingStyle,
                            children: [
                              TextSpan(text: 'Real ', style: realStyle),
                              TextSpan(text: 'Insights.\n'),
                              TextSpan(text: 'Real ', style: realStyle),
                              TextSpan(text: 'Outcomes.', style: whiteItalicStyle),
                            ],
                          ),
                        )
                      : Text(heading, style: headingStyle),
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
                          onPressed: () => _goToPage(_currentPage - 1),
                        ),
                        const SizedBox(width: 12),
                        _NavButton(
                          icon: LucideIcons.chevronRight,
                          onPressed: () => _goToPage(_currentPage + 1),
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
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
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
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerContent,
              const SizedBox(height: 40),
              SizedBox(
                height: _cardsHeight,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (p) {
                    setState(() => _currentPage = p);
                    _scheduleFlipAfterTransition(p);
                  },
                  itemCount: (_placeholders.length / _cardsPerPage).ceil(),
                  itemBuilder: (context, pageIndex) {
                    final start = pageIndex * _cardsPerPage;
                    final end = math.min(start + _cardsPerPage, _placeholders.length);
                    final isReadyForFlip = _pageReadyForFlip != null &&
                        pageIndex == _pageReadyForFlip;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = start; i < end; i++) ...[
                          if (i > start) const SizedBox(width: _cardGap),
                          Expanded(
                            child: SizedBox(
                              height: _cardsHeight,
                              child: _FlipTestimonialCard(
                                shouldAnimate: isReadyForFlip,
                                flipDelay: Duration(
                                  milliseconds: _flipStaggerDelay.inMilliseconds * (i - start),
                                ),
                                flipDuration: _flipDuration,
                                child: _TestimonialCard(
                                  quote: _placeholders[i].quote,
                                  name: _placeholders[i].name,
                                  location: _placeholders[i].location,
                                  imageIndex: i,
                                  imagePath: _placeholders[i].imagePath,
                                  isBlank: _placeholders[i].isBlank,
                                ),
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
        ),
      ),
    );
  }
}

class _FlipTestimonialCard extends StatefulWidget {
  const _FlipTestimonialCard({
    required this.child,
    required this.shouldAnimate,
    required this.flipDelay,
    required this.flipDuration,
  });

  final Widget child;
  final bool shouldAnimate;
  final Duration flipDelay;
  final Duration flipDuration;

  @override
  State<_FlipTestimonialCard> createState() => _FlipTestimonialCardState();
}

class _FlipTestimonialCardState extends State<_FlipTestimonialCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasStarted = false;

  void _maybeStartFlip() {
    if (!widget.shouldAnimate || _hasStarted || !mounted) return;
    _hasStarted = true;
    Future<void>.delayed(widget.flipDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.flipDuration,
    );
    _animation = Tween<double>(begin: math.pi / 2, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _maybeStartFlip();
  }

  @override
  void didUpdateWidget(covariant _FlipTestimonialCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _maybeStartFlip();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: child,
        );
      },
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

  @override
  Widget build(BuildContext context) {
    final shadow = _isHovered ? AppShadows.cardHover : AppShadows.card;
    final borderColor = _isHovered ? AppColors.borderLight.withValues(alpha: 0.5) : AppColors.borderDark;
    final scale = _isHovered ? 1.02 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: shadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 180,
              width: double.infinity,
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
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.75),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.name.toUpperCase(),
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onPrimary.withValues(
                                    alpha: widget.isBlank ? 0.5 : 1,
                                  ),
                                  letterSpacing: 0.5,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.location,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onPrimary.withValues(
                                    alpha: widget.isBlank ? 0.45 : 0.9,
                                  ),
                                  fontSize: 12,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        widget.isBlank ? '—' : '"${widget.quote}"',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          fontStyle: widget.isBlank ? FontStyle.normal : FontStyle.italic,
                          color: AppColors.onPrimary.withValues(
                            alpha: widget.isBlank ? 0.4 : 0.92,
                          ),
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${widget.name} | ${widget.location}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onPrimary.withValues(
                          alpha: widget.isBlank ? 0.35 : 0.6,
                        ),
                        fontSize: 12,
                      ),
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
