import 'package:flutter/material.dart';
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppContent.assetHeroBackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.overlayDark.withValues(alpha: 0.6),
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
    const lightStyle = TextStyle(
      color: _textLight,
      fontWeight: FontWeight.w600,
      height: 1.25,
    );
    const highlightStyle = TextStyle(
      color: AppColors.accent,
      fontWeight: FontWeight.w600,
      height: 1.25,
    );
    final baseSize = Theme.of(context).textTheme.headlineSmall?.fontSize ?? 24;
    final normal = lightStyle.copyWith(fontSize: baseSize);
    final highlight = highlightStyle.copyWith(fontSize: baseSize);

    final String s = l10n.sectionKnowledgeHeading;
    final List<InlineSpan> spans = _highlightPhrases(s, ['Real Change.', 'instruction.', 'Real Change', 'instruction'], normal, highlight);
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
    final bodyStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: _textMuted,
          height: 1.6,
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(l10n.sectionKnowledgeBody, style: bodyStyle),
        const SizedBox(height: 16),
        Text(l10n.sectionKnowledgeBody2, style: bodyStyle),
      ],
    );
  }
}

class _AcademyCard extends StatelessWidget {
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

  static const Color _textLight = Color(0xFFE8E8E8);
  static const Color _textMuted = Color(0xFFB0B0B0);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark, width: 1),
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onExplore,
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
                      width: 80,
                      height: 80,
                      cacheWidth: 160,
                      cacheHeight: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, size: 40, color: AppColors.accent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: _textLight,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _textMuted,
                        height: 1.5,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.exploreCourses,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
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
    );
  }
}
