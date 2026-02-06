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

    final blocks = [
      _ConsultBlock(
        category: l10n.consult1Category,
        method: l10n.consult1Method,
        question: l10n.consult1Question,
        description: l10n.consult1Desc,
        icon: LucideIcons.user,
        onGetConsultation: () => context.push('/appointments'),
      ),
      _ConsultBlock(
        category: l10n.consult2Category,
        method: l10n.consult2Method,
        question: l10n.consult2Question,
        description: l10n.consult2Desc,
        icon: LucideIcons.calendar,
        onGetConsultation: () => context.push('/appointments'),
      ),
      _ConsultBlock(
        category: l10n.consult3Category,
        method: l10n.consult3Method,
        question: l10n.consult3Question,
        description: l10n.consult3Desc,
        icon: LucideIcons.home,
        onGetConsultation: () => context.push('/appointments'),
      ),
      _ConsultBlock(
        category: l10n.consult4Category,
        method: l10n.consult4Method,
        question: l10n.consult4Question,
        description: l10n.consult4Desc,
        icon: LucideIcons.clock,
        onGetConsultation: () => context.push('/appointments'),
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
          padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSectionHeading(context, l10n),
                  const SizedBox(height: 20),
                  Text(
                    l10n.sectionMapIntro,
                    style: GoogleFonts.exo2(
                      fontSize: width < 600 ? 15 : 17,
                      height: 1.6,
                      color: AppColors.onPrimary.withValues(alpha: 0.92),
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
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
    final normal = GoogleFonts.exo2(
      color: AppColors.onPrimary,
      fontWeight: FontWeight.w600,
      fontSize: size,
      height: 1.3,
    );
    final highlight = GoogleFonts.condiment(
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
    required this.onGetConsultation,
  });

  final String category;
  final String method;
  final String question;
  final String description;
  final IconData icon;
  final VoidCallback onGetConsultation;

  @override
  State<_ConsultBlock> createState() => _ConsultBlockState();
}

class _ConsultBlockState extends State<_ConsultBlock> {
  bool _isHovered = false;

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
                        ),
                        child: Icon(widget.icon, size: 32, color: AppColors.accent),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.category,
                              style: GoogleFonts.exo2(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600,
                                fontSize: 19,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.method,
                              style: GoogleFonts.exo2(
                                color: AppColors.onPrimary.withValues(alpha: 0.78),
                                fontSize: 14,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 44,
                    child: Text(
                      widget.question,
                      style: GoogleFonts.exo2(
                        fontStyle: FontStyle.italic,
                        color: AppColors.onPrimary,
                        fontSize: 15,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 46,
                    child: Text(
                      widget.description,
                      style: GoogleFonts.exo2(
                        color: AppColors.onPrimary.withValues(alpha: 0.88),
                        fontSize: 15,
                        height: 1.45,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: widget.onGetConsultation,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.onPrimary,
                      side: const BorderSide(color: AppColors.accent, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      l10n.getConsultation,
                      style: GoogleFonts.exo2(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
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
