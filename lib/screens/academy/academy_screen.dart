import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 80),
          const _AcademyHero(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isNarrow ? 16 : 32,
              vertical: isNarrow ? 32 : 40,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeadingWithHighlight(context, l10n.sectionKnowledgeHeading),
                    const SizedBox(height: 12),
                    Text(
                      l10n.sectionKnowledgeBody,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.onSurfaceVariantDark,
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.sectionKnowledgeBody2,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.onSurfaceVariantDark,
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 48),
                    if (isNarrow) ...[
                      _AcademyDisciplineCard(
                        imageAsset: AppContent.assetBackgroundDirection,
                        icon: LucideIcons.compass,
                        title: l10n.academyQiMen,
                        description: l10n.academyQiMenDesc,
                        about: l10n.academyQiMenAbout,
                        topics: l10n.academyQiMenTopics,
                        onExplore: () => context.push('/consultations'),
                      ),
                      const SizedBox(height: 24),
                      _AcademyDisciplineCard(
                        imageAsset: AppContent.assetStoryBackground,
                        icon: LucideIcons.user,
                        title: l10n.academyBaZi,
                        description: l10n.academyBaZiDesc,
                        about: l10n.academyBaZiAbout,
                        topics: l10n.academyBaZiTopics,
                        onExplore: () => context.push('/consultations'),
                      ),
                      const SizedBox(height: 24),
                      _AcademyDisciplineCard(
                        imageAsset: AppContent.assetAboutHero,
                        icon: LucideIcons.home,
                        title: l10n.academyFengShui,
                        description: l10n.academyFengShuiDesc,
                        about: l10n.academyFengShuiAbout,
                        topics: l10n.academyFengShuiTopics,
                        onExplore: () => context.push('/consultations'),
                      ),
                      const SizedBox(height: 24),
                      _AcademyDisciplineCard(
                        imageAsset: AppContent.assetEventCard,
                        icon: LucideIcons.calendarDays,
                        title: l10n.academyDateSelection,
                        description: l10n.academyDateSelectionDesc,
                        about: l10n.academyDateSelectionAbout,
                        topics: l10n.academyDateSelectionTopics,
                        onExplore: () => context.push('/consultations'),
                      ),
                      const SizedBox(height: 24),
                      _AcademyDisciplineCard(
                        imageAsset: AppContent.assetAcademy,
                        icon: LucideIcons.bookOpen,
                        title: l10n.academyIChing,
                        description: l10n.academyIChingDesc,
                        about: l10n.academyIChingAbout,
                        topics: l10n.academyIChingTopics,
                        onExplore: () => context.push('/consultations'),
                      ),
                      const SizedBox(height: 24),
                      _AcademyDisciplineCard(
                        imageAsset: AppContent.assetEventMain,
                        icon: LucideIcons.mountain,
                        title: l10n.academyMaoShan,
                        description: l10n.academyMaoShanDesc,
                        about: l10n.academyMaoShanAbout,
                        topics: l10n.academyMaoShanTopics,
                        onExplore: () => context.push('/consultations'),
                      ),
                    ] else
                      Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: _AcademyDisciplineCard(
                                    imageAsset: AppContent.assetBackgroundDirection,
                                    icon: LucideIcons.compass,
                                    title: l10n.academyQiMen,
                                    description: l10n.academyQiMenDesc,
                                    about: l10n.academyQiMenAbout,
                                    topics: l10n.academyQiMenTopics,
                                    onExplore: () => context.push('/consultations'),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: _AcademyDisciplineCard(
                                    imageAsset: AppContent.assetStoryBackground,
                                    icon: LucideIcons.user,
                                    title: l10n.academyBaZi,
                                    description: l10n.academyBaZiDesc,
                                    about: l10n.academyBaZiAbout,
                                    topics: l10n.academyBaZiTopics,
                                    onExplore: () => context.push('/consultations'),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: _AcademyDisciplineCard(
                                    imageAsset: AppContent.assetAboutHero,
                                    icon: LucideIcons.home,
                                    title: l10n.academyFengShui,
                                    description: l10n.academyFengShuiDesc,
                                    about: l10n.academyFengShuiAbout,
                                    topics: l10n.academyFengShuiTopics,
                                    onExplore: () => context.push('/consultations'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: _AcademyDisciplineCard(
                                    imageAsset: AppContent.assetEventCard,
                                    icon: LucideIcons.calendarDays,
                                    title: l10n.academyDateSelection,
                                    description: l10n.academyDateSelectionDesc,
                                    about: l10n.academyDateSelectionAbout,
                                    topics: l10n.academyDateSelectionTopics,
                                    onExplore: () => context.push('/consultations'),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: _AcademyDisciplineCard(
                                    imageAsset: AppContent.assetAcademy,
                                    icon: LucideIcons.bookOpen,
                                    title: l10n.academyIChing,
                                    description: l10n.academyIChingDesc,
                                    about: l10n.academyIChingAbout,
                                    topics: l10n.academyIChingTopics,
                                    onExplore: () => context.push('/consultations'),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: _AcademyDisciplineCard(
                                    imageAsset: AppContent.assetEventMain,
                                    icon: LucideIcons.mountain,
                                    title: l10n.academyMaoShan,
                                    description: l10n.academyMaoShanDesc,
                                    about: l10n.academyMaoShanAbout,
                                    topics: l10n.academyMaoShanTopics,
                                    onExplore: () => context.push('/consultations'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 48),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevatedDark.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderDark, width: 1),
                      ),
                      child: isNarrow
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  l10n.academyMoreCoursesNote,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.onSurfaceVariantDark,
                                        height: 1.5,
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                FilledButton.icon(
                                  onPressed: () => context.push('/contact'),
                                  icon: const Icon(LucideIcons.messageCircle, size: 20),
                                  label: Text(l10n.contactUs),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.accent,
                                    foregroundColor: AppColors.onAccent,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    l10n.academyMoreCoursesNote,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AppColors.onSurfaceVariantDark,
                                          height: 1.5,
                                          fontStyle: FontStyle.italic,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                FilledButton.icon(
                                  onPressed: () => context.push('/contact'),
                                  icon: const Icon(LucideIcons.messageCircle, size: 20),
                                  label: Text(l10n.contactUs),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.accent,
                                    foregroundColor: AppColors.onAccent,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the section heading with "Real Change" highlighted in Condiment font.
  static Widget _buildHeadingWithHighlight(BuildContext context, String heading) {
    const String highlightPhrase = 'Real Change';
    final theme = Theme.of(context).textTheme.headlineMedium;
    final baseStyle = theme?.copyWith(
      color: AppColors.onPrimary,
      fontWeight: FontWeight.w600,
    ) ?? const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w600);
    final highlightStyle = GoogleFonts.condiment(
      color: AppColors.accent,
      fontWeight: FontWeight.bold,
      fontSize: (theme?.fontSize ?? 28) * 1.1,
      height: theme?.height ?? 1.3,
    );

    final idx = heading.indexOf(highlightPhrase);
    if (idx < 0) {
      return Text(heading, style: baseStyle);
    }
    final before = heading.substring(0, idx);
    final matched = highlightPhrase;
    final after = heading.substring(idx + matched.length);

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: before),
          TextSpan(text: matched, style: highlightStyle),
          TextSpan(text: after),
        ],
      ),
    );
  }
}

/// Hero banner at the top of the Academy page (main.jpg, no title, tall for visibility).
class _AcademyHero extends StatelessWidget {
  const _AcademyHero();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = width < 600 ? 320.0 : (width < 900 ? 420.0 : 520.0);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppContent.assetAppsHero,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.backgroundDark.withValues(alpha: 0.35),
                  AppColors.backgroundDark.withValues(alpha: 0.15),
                  AppColors.backgroundDark.withValues(alpha: 0.08),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Single discipline card with image, title, description, about text, topics, and CTA.
/// Uses fixed spacing and line counts so all three cards have identical size and height.
class _AcademyDisciplineCard extends StatefulWidget {
  const _AcademyDisciplineCard({
    required this.imageAsset,
    required this.icon,
    required this.title,
    required this.description,
    required this.about,
    required this.topics,
    required this.onExplore,
  });

  final String imageAsset;
  final IconData icon;
  final String title;
  final String description;
  final String about;
  final String topics;
  final VoidCallback onExplore;

  @override
  State<_AcademyDisciplineCard> createState() => _AcademyDisciplineCardState();
}

class _AcademyDisciplineCardState extends State<_AcademyDisciplineCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shadow = _isHovered ? AppShadows.cardHover : AppShadows.card;
    final borderColor =
        _isHovered ? AppColors.borderLight.withValues(alpha: 0.5) : AppColors.borderDark;
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
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: shadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onExplore,
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        child: AspectRatio(
                          aspectRatio: 16 / 10,
                          child: Image.asset(
                            widget.imageAsset,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.accent.withValues(alpha: 0.15),
                              child: Icon(widget.icon, size: 48, color: AppColors.accent),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundDark.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.4)),
                          ),
                          child: Icon(widget.icon, size: 24, color: AppColors.accent),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 28,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.title,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onPrimary,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 40,
                          child: Text(
                            widget.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.accentLight.withValues(alpha: 0.9),
                                  height: 1.4,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 63,
                          child: Text(
                            widget.about,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  height: 1.5,
                                  color: AppColors.onSurfaceVariantDark,
                                ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 36,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(LucideIcons.sparkles, size: 14, color: AppColors.accent),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  widget.topics,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppColors.onSurfaceVariantDark,
                                        height: 1.35,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 24,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.exploreCourses,
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const Icon(Icons.arrow_forward, size: 18, color: AppColors.accent),
                            ],
                          ),
                        ),
                      ],
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
