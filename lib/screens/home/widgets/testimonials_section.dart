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
  });

  final String quote;
  final String name;
  final String location;
}

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  static const _placeholders = [
    TestimonialItem(
      quote: 'Master Elf is the best',
      name: 'Chong Sarachan',
      location: 'Phnom Penh',
    ),
    TestimonialItem(
      quote: 'Master Elf is the best',
      name: 'Lana',
      location: 'Phnom Penh',
    ),
    TestimonialItem(
      quote: 'Master Elf is the best',
      name: 'kenway',
      location: 'Phnom Penh',
    ),
    TestimonialItem(
      quote: 'Master Elf is the best',
      name: 'Kai Wee',
      location: 'Singapore',
    ),
  ];

  final ScrollController _scrollController = ScrollController();
  static const double _cardWidth = 280;
  static const double _cardGap = 20;
  static const double _cardsRowMinWidth = 1000;
  static const double _cardsHeight = 380;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollCarousel(int delta) {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;
    final next = (current + delta * (_cardWidth + _cardGap)).clamp(0.0, max);
    _scrollController.animateTo(
      next,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
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
                  _NavButton(icon: LucideIcons.chevronLeft, onPressed: () => _scrollCarousel(-1)),
                  const SizedBox(width: 12),
                  _NavButton(icon: LucideIcons.chevronRight, onPressed: () => _scrollCarousel(1)),
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
                        _NavButton(icon: LucideIcons.chevronLeft, onPressed: () => _scrollCarousel(-1)),
                        const SizedBox(width: 12),
                        _NavButton(icon: LucideIcons.chevronRight, onPressed: () => _scrollCarousel(1)),
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
                child: width >= _cardsRowMinWidth
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < _placeholders.length; i++) ...[
                            if (i > 0) const SizedBox(width: _cardGap),
                            Expanded(
                              child: _TestimonialCard(
                                quote: _placeholders[i].quote,
                                name: _placeholders[i].name,
                                location: _placeholders[i].location,
                                imageIndex: i,
                              ),
                            ),
                          ],
                        ],
                      )
                    : ListView.separated(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: _placeholders.length,
                        separatorBuilder: (_, __) => const SizedBox(width: _cardGap),
                        itemBuilder: (context, index) {
                          final t = _placeholders[index];
                          return SizedBox(
                            width: _cardWidth,
                            child: _TestimonialCard(
                              quote: t.quote,
                              name: t.name,
                              location: t.location,
                              imageIndex: index,
                            ),
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
  });

  final String quote;
  final String name;
  final String location;
  final int imageIndex;

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
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.imageIndex.isEven ? AppContent.assetTestimonialProfile : AppContent.assetTestimonialParticipant,
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
                                  color: AppColors.onPrimary,
                                  letterSpacing: 0.5,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.location,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.onPrimary.withValues(alpha: 0.9),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"${widget.quote}"',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                      color: AppColors.onPrimary.withValues(alpha: 0.92),
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${widget.name} | ${widget.location}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
