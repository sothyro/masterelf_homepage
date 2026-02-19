import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../widgets/academy_card.dart';

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

    final paddingV = isNarrow ? 48.0 : 88.0;
    final paddingH = isNarrow ? 16.0 : 24.0;
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minSectionHeight),
      padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF24201A),           // warm dark (top)
            Color(0xFF161210),           // mid
            Color(0xFF0A0808),           // deep dark (bottom)
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
                          AcademyCard(
                            icon: LucideIcons.user,
                            title: l10n.academyBaZi,
                            description: l10n.academyBaZiDesc,
                            imageAsset: AppContent.assetBaziHarmony,
                            onExplore: () => context.push('/apps'),
                          ),
                          const SizedBox(height: 20),
                          AcademyCard(
                            icon: LucideIcons.home,
                            title: l10n.academyFengShui,
                            description: l10n.academyFengShuiDesc,
                            imageAsset: AppContent.assetAcademyFengShui,
                            onExplore: () => context.push('/apps'),
                          ),
                          const SizedBox(height: 20),
                          AcademyCard(
                            icon: LucideIcons.compass,
                            title: l10n.academyQiMen,
                            description: l10n.academyQiMenDesc,
                            imageAsset: AppContent.assetAcademyQiMen,
                            onExplore: () => context.push('/apps'),
                          ),
                        ],
                      );
                    }
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                        Expanded(
                          child: AcademyCard(
                            icon: LucideIcons.user,
                            title: l10n.academyBaZi,
                            description: l10n.academyBaZiDesc,
                            imageAsset: AppContent.assetBaziHarmony,
                            onExplore: () => context.push('/apps'),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: AcademyCard(
                            icon: LucideIcons.home,
                            title: l10n.academyFengShui,
                            description: l10n.academyFengShuiDesc,
                            imageAsset: AppContent.assetAcademyFengShui,
                            onExplore: () => context.push('/apps'),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: AcademyCard(
                            icon: LucideIcons.compass,
                            title: l10n.academyQiMen,
                            description: l10n.academyQiMenDesc,
                            imageAsset: AppContent.assetAcademyQiMen,
                            onExplore: () => context.push('/apps'),
                          ),
                        ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildHeading(BuildContext context, AppLocalizations l10n) {
    final width = MediaQuery.sizeOf(context).width;
    final baseSize = width < 600 ? 22.0 : (width < 900 ? 26.0 : 32.0);
    final normal = textStyleWithLocale(
      context,
      isHeading: true,
      fontSize: baseSize,
      fontWeight: FontWeight.w600,
      color: _textLight,
    ).copyWith(height: 1.3);
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
    final bodyStyle = textStyleWithLocale(
      context,
      isHeading: false,
      fontSize: width < 600 ? 15 : 17,
      fontWeight: FontWeight.w400,
      color: _textMuted,
    ).copyWith(height: 1.65);
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
