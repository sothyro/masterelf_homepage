import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../config/app_content.dart';
import '../../../utils/breakpoints.dart';
import '../../../utils/launcher_utils.dart';

/// Dark section with split heading/body and academy cards (Joey Yap–style).
class AcademiesSection extends StatelessWidget {
  const AcademiesSection({super.key});

  static const Color _textLight = Color(0xFFE8E8E8);
  static const Color _textMuted = Color(0xFFB0B0B0);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final minSectionHeight = viewportHeight * 0.9;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minSectionHeight),
      padding: const EdgeInsets.symmetric(vertical: 88, horizontal: 24),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppContent.assetHeroBackground),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.overlayDark.withValues(alpha: 0.7),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNarrow) ...[
                  _buildHeading(context, l10n),
                  const SizedBox(height: 24),
                  _buildBody(context, l10n),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 32),
                          child: _buildHeading(context, l10n),
                        ),
                      ),
                      Expanded(
                        child: _buildBody(context, l10n),
                      ),
                    ],
                  ),
                const SizedBox(height: 56),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final narrow = Breakpoints.isMobile(constraints.maxWidth);
                    if (narrow) {
                      return Column(
                        children: [
                          _AcademyCard(
                            icon: LucideIcons.compass,
                            title: l10n.academyQiMen,
                            description: l10n.academyQiMenDesc,
                            onExplore: () => launchUrlExternal(AppContent.academyExploreUrl),
                          ),
                          const SizedBox(height: 20),
                          _AcademyCard(
                            icon: LucideIcons.user,
                            title: l10n.academyBaZi,
                            description: l10n.academyBaZiDesc,
                            onExplore: () => launchUrlExternal(AppContent.academyExploreUrl),
                          ),
                          const SizedBox(height: 20),
                          _AcademyCard(
                            icon: LucideIcons.home,
                            title: l10n.academyFengShui,
                            description: l10n.academyFengShuiDesc,
                            onExplore: () => launchUrlExternal(AppContent.academyExploreUrl),
                          ),
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _AcademyCard(
                            icon: LucideIcons.compass,
                            title: l10n.academyQiMen,
                            description: l10n.academyQiMenDesc,
                            onExplore: () => launchUrlExternal(AppContent.academyExploreUrl),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _AcademyCard(
                            icon: LucideIcons.user,
                            title: l10n.academyBaZi,
                            description: l10n.academyBaZiDesc,
                            onExplore: () => launchUrlExternal(AppContent.academyExploreUrl),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: _AcademyCard(
                            icon: LucideIcons.home,
                            title: l10n.academyFengShui,
                            description: l10n.academyFengShuiDesc,
                            onExplore: () => launchUrlExternal(AppContent.academyExploreUrl),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeading(BuildContext context, AppLocalizations l10n) {
    final width = MediaQuery.sizeOf(context).width;
    final baseSize = width < 600 ? 22.0 : (width < 900 ? 26.0 : 32.0);
    final normal = GoogleFonts.exo2(
      color: _textLight,
      fontWeight: FontWeight.w600,
      fontSize: baseSize,
      height: 1.3,
    );
    final highlight = GoogleFonts.condiment(
      color: AppColors.accent,
      fontWeight: FontWeight.bold,
      fontSize: baseSize * 1.15,
      height: 1.3,
    );

    final String s = l10n.sectionKnowledgeHeading;
    final List<InlineSpan> spans = _highlightPhrases(
      s,
      ['Real Change.', 'instruction.', 'Real Change', 'instruction', 'Knowledge.'],
      normal,
      highlight,
    );
    return RichText(
      text: TextSpan(children: spans),
    );
  }

  List<InlineSpan> _highlightPhrases(String text, List<String> phrases, TextStyle normal, TextStyle highlight) {
    final List<InlineSpan> result = [];
    int start = 0;
    while (start < text.length) {
      int nextIndex = -1;
      String? matched;
      for (final phrase in phrases) {
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

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    final width = MediaQuery.sizeOf(context).width;
    final bodyStyle = GoogleFonts.exo2(
      color: _textMuted,
      fontSize: width < 600 ? 15 : 17,
      height: 1.65,
      fontWeight: FontWeight.w400,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l10n.sectionKnowledgeBody, style: bodyStyle),
        const SizedBox(height: 18),
        Text(l10n.sectionKnowledgeBody2, style: bodyStyle),
      ],
    );
  }
}

class _AcademyCard extends StatefulWidget {
  const _AcademyCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onExplore,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onExplore;

  @override
  State<_AcademyCard> createState() => _AcademyCardState();
}

class _AcademyCardState extends State<_AcademyCard> {
  bool _isHovered = false;

  static const Color _textLight = Color(0xFFE8E8E8);
  static const Color _textMuted = Color(0xFFB0B0B0);

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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: shadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onExplore,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          AppContent.assetAcademy,
                          width: 160,
                          height: 160,
                          cacheWidth: 320,
                          cacheHeight: 320,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(widget.icon, size: 56, color: AppColors.accent),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.title,
                      style: GoogleFonts.exo2(
                        color: _textLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 46,
                      child: Text(
                        widget.description,
                        style: GoogleFonts.exo2(
                          color: _textMuted,
                          fontSize: 15,
                          height: 1.55,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.exploreCourses,
                          style: GoogleFonts.exo2(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward, size: 18, color: AppColors.accent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
