import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';

class ConsultationsSection extends StatelessWidget {
  const ConsultationsSection({super.key});

  static const double _cardGap = 24.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    // Service IDs must match Consultations page: bazi, fengshui, dateselection, qimeniching, maosan, publications
    const serviceIds = ['bazi', 'fengshui', 'dateselection', 'qimeniching', 'maosan', 'publications'];
    final blocks = [
      _ConsultBlock(
        category: l10n.consult1Category,
        method: l10n.consult1Method,
        question: l10n.consult1Question,
        description: l10n.consult1Desc,
        icon: LucideIcons.user,
        serviceId: serviceIds[0],
        onGetConsultation: () => context.push('/consultations?service=${serviceIds[0]}'),
      ),
      _ConsultBlock(
        category: l10n.consult2Category,
        method: l10n.consult2Method,
        question: l10n.consult2Question,
        description: l10n.consult2Desc,
        icon: LucideIcons.calendar,
        serviceId: serviceIds[1],
        onGetConsultation: () => context.push('/consultations?service=${serviceIds[1]}'),
      ),
      _ConsultBlock(
        category: l10n.consult3Category,
        method: l10n.consult3Method,
        question: l10n.consult3Question,
        description: l10n.consult3Desc,
        icon: LucideIcons.home,
        serviceId: serviceIds[2],
        onGetConsultation: () => context.push('/consultations?service=${serviceIds[2]}'),
      ),
      _ConsultBlock(
        category: l10n.consult4Category,
        method: l10n.consult4Method,
        question: l10n.consult4Question,
        description: l10n.consult4Desc,
        icon: LucideIcons.clock,
        serviceId: serviceIds[3],
        onGetConsultation: () => context.push('/consultations?service=${serviceIds[3]}'),
      ),
      _ConsultBlock(
        category: l10n.consult5Category,
        method: l10n.consult5Method,
        question: l10n.consult5Question,
        description: l10n.consult5Desc,
        icon: LucideIcons.sparkles,
        serviceId: serviceIds[4],
        onGetConsultation: () => context.push('/consultations?service=${serviceIds[4]}'),
      ),
      _ConsultBlock(
        category: l10n.consult6Category,
        method: l10n.consult6Method,
        question: l10n.consult6Question,
        description: l10n.consult6Desc,
        icon: LucideIcons.bookOpen,
        serviceId: serviceIds[5],
        onGetConsultation: () => context.push('/consultations?service=${serviceIds[5]}'),
      ),
    ];

    // Stack must have a non-positioned child so it gets finite size inside
    // SingleChildScrollView (unbounded height). Background/overlay use
    // Positioned.fill; content is the sizing child.
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Image.asset(
            AppContent.assetBackgroundDirection,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.surfaceDark,
              child: const Center(
                child: Icon(Icons.broken_image_outlined, size: 48, color: AppColors.onPrimary),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            color: AppColors.overlayDark.withValues(alpha: 0.58),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 40 : 56,
            horizontal: isMobile ? 16 : 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSectionHeading(context, l10n),
                  const SizedBox(height: 20),
                  Builder(
                    builder: (context) {
                      final isKm = Localizations.localeOf(context).languageCode == 'km';
                      return Text(
                        l10n.sectionMapIntro,
                        style: (isKm ? GoogleFonts.siemreap : GoogleFonts.exo2)(
                          fontSize: width < 600 ? 15 : 17,
                          height: 1.6,
                          color: AppColors.onPrimary.withValues(alpha: 0.92),
                          fontWeight: FontWeight.w400,
                          letterSpacing: isKm ? 0 : null,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  const SizedBox(height: 44),
                  if (isMobile) ...[
                    ...blocks.map((b) => Padding(
                          padding: const EdgeInsets.only(bottom: _cardGap),
                          child: b,
                        )),
                  ] else
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: blocks[0]),
                            const SizedBox(width: _cardGap),
                            Expanded(child: blocks[1]),
                          ],
                        ),
                        const SizedBox(height: _cardGap),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: blocks[2]),
                            const SizedBox(width: _cardGap),
                            Expanded(child: blocks[3]),
                          ],
                        ),
                        const SizedBox(height: _cardGap),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: blocks[4]),
                            const SizedBox(width: _cardGap),
                            Expanded(child: blocks[5]),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeading(BuildContext context, AppLocalizations l10n) {
    final width = MediaQuery.sizeOf(context).width;
    final size = width < 600 ? 22.0 : (width < 900 ? 26.0 : 32.0);
    final isKm = Localizations.localeOf(context).languageCode == 'km';
    final normal = isKm
        ? GoogleFonts.dangrek(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: size,
            height: 1.3,
            letterSpacing: 0,
          )
        : GoogleFonts.exo2(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: size,
            height: 1.3,
          );
    final highlight = highlightStyleForLocale(
      context,
      color: AppColors.accent,
      fontWeight: FontWeight.bold,
      fontSize: size * 1.12,
      height: 1.3,
    );
    final s = l10n.sectionMapHeading;
    final phrases = ['RoadMap.', 'RoadMap', 'Map.', 'Map', 'correct way', '地图'];
    final spans = _highlightPhrases(s, phrases, normal, highlight);
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: spans),
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

class _ConsultBlock extends StatefulWidget {
  const _ConsultBlock({
    required this.category,
    required this.method,
    required this.question,
    required this.description,
    required this.icon,
    required this.serviceId,
    required this.onGetConsultation,
  });

  final String category;
  final String method;
  final String question;
  final String description;
  final IconData icon;
  final String serviceId;
  final VoidCallback onGetConsultation;

  @override
  State<_ConsultBlock> createState() => _ConsultBlockState();
}

class _ConsultBlockState extends State<_ConsultBlock> {
  bool _isHovered = false;

  /// Card header: Dangrek for Khmer, Exo2 otherwise.
  static TextStyle _cardHeaderStyle(BuildContext context) {
    final isKm = Localizations.localeOf(context).languageCode == 'km';
    if (isKm) {
      return GoogleFonts.dangrek(
        color: AppColors.accent,
        fontWeight: FontWeight.w700,
        fontSize: 18,
        height: 1.25,
        letterSpacing: 0,
      );
    }
    return GoogleFonts.exo2(
      color: AppColors.accent,
      fontWeight: FontWeight.w700,
      fontSize: 18,
      height: 1.25,
      letterSpacing: 0.3,
    );
  }

  /// Card subtext (method): Siem Reap for Khmer, Exo2 otherwise.
  static TextStyle _cardSubtextStyle(BuildContext context) {
    final isKm = Localizations.localeOf(context).languageCode == 'km';
    if (isKm) {
      return GoogleFonts.siemreap(
        color: AppColors.onPrimary.withValues(alpha: 0.7),
        fontSize: 13,
        height: 1.3,
        letterSpacing: 0,
      );
    }
    return GoogleFonts.exo2(
      color: AppColors.onPrimary.withValues(alpha: 0.7),
      fontSize: 13,
      height: 1.3,
    );
  }

  /// Card body text: Siem Reap for Khmer, Exo2 otherwise.
  static TextStyle _cardBodyStyle(BuildContext context) {
    final isKm = Localizations.localeOf(context).languageCode == 'km';
    if (isKm) {
      return GoogleFonts.siemreap(
        color: AppColors.onPrimary,
        fontSize: 14,
        height: 1.55,
        letterSpacing: 0,
      );
    }
    return GoogleFonts.exo2(
      color: AppColors.onPrimary,
      fontSize: 14,
      height: 1.55,
      fontWeight: FontWeight.w400,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onGetConsultation,
            borderRadius: BorderRadius.circular(12),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevatedDark.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 1),
                boxShadow: shadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.4),
                            width: 1,
                          ),
                        ),
                        child: Icon(widget.icon, size: 28, color: AppColors.accent),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.category,
                              style: _cardHeaderStyle(context),
                            ),
                            if (widget.method != widget.category) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.method,
                                style: _cardSubtextStyle(context),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.question,
                    style: _cardBodyStyle(context).copyWith(
                      fontStyle: FontStyle.italic,
                      color: AppColors.onPrimary.withValues(alpha: 0.95),
                      fontSize: 15,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 1,
                    margin: const EdgeInsets.only(left: 0),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary.withValues(alpha: 0.12),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.description,
                    style: _cardBodyStyle(context).copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.9),
                      fontSize: 14,
                      height: 1.55,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: widget.onGetConsultation,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.onPrimary,
                        side: const BorderSide(color: AppColors.accent, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        l10n.getConsultation,
                        style: _cardBodyStyle(context).copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
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
    );
  }
}
