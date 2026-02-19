import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../widgets/academy_card.dart';

/// Master Elf's Journey page: hero, story, Period 9, and The Rise of the Phoenix.
class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

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
          _JourneyHero(isNarrow: isNarrow),
          Padding(
            padding: EdgeInsets.only(
              top: isNarrow ? 32 : 56,
              bottom: isNarrow ? 40 : 64,
              left: isNarrow ? 16 : 24,
              right: isNarrow ? 16 : 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 840),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SectionTheStory(l10n: l10n),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _SectionPeriod9(l10n: l10n),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _SectionPhoenix(l10n: l10n),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _JourneyAcademyCards(l10n: l10n, isNarrow: isNarrow),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Hero section: full-height background and gradient only.
class _JourneyHero extends StatelessWidget {
  const _JourneyHero({required this.isNarrow});

  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isNarrow ? 780 : 720,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              AppContent.assetJourneyHero,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const SizedBox.expand(),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundDark.withValues(alpha: 0.72),
                    AppColors.backgroundDark.withValues(alpha: 0.88),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// "The Story" section: section title + three story cards.
class _SectionTheStory extends StatelessWidget {
  const _SectionTheStory({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.journeySectionTheStory,
          style: GoogleFonts.condiment(
            fontSize: isNarrow ? 26 : 32,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 28),
        if (isNarrow)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StoryCard(step: 1, text: l10n.journeyStory1),
              const SizedBox(height: 20),
              _StoryCard(step: 2, text: l10n.journeyStory2),
              const SizedBox(height: 20),
              _StoryCard(step: 3, text: l10n.journeyStory3),
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StoryCard(step: 1, text: l10n.journeyStory1),
              const SizedBox(height: 24),
              _StoryCard(step: 2, text: l10n.journeyStory2),
              const SizedBox(height: 24),
              _StoryCard(step: 3, text: l10n.journeyStory3),
            ],
          ),
      ],
    );
  }
}

class _StoryCard extends StatefulWidget {
  const _StoryCard({required this.step, required this.text});

  final int step;
  final String text;

  @override
  State<_StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<_StoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? AppColors.borderLight.withValues(alpha: 0.4)
                : AppColors.borderDark,
            width: _hovered ? 1.5 : 1,
          ),
          boxShadow: _hovered ? AppShadows.cardHover : AppShadows.card,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.borderLight.withValues(alpha: 0.35),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '${widget.step}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  widget.text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                        height: 1.6,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Period 9 and the New Era — distinct card with icon.
class _SectionPeriod9 extends StatelessWidget {
  const _SectionPeriod9({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceElevatedDark,
            AppColors.surfaceElevatedDark.withValues(alpha: 0.98),
            AppColors.backgroundDark.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderLight.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          ...AppShadows.card,
          BoxShadow(
            color: AppColors.accentGlow.withValues(alpha: 0.08),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.borderLight.withValues(alpha: 0.4),
                  ),
                ),
                child: Icon(
                  LucideIcons.flame,
                  size: 28,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  l10n.journeyPeriod9Title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.journeyPeriod9Body,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}

/// The Rise of the Phoenix — closing section with accent typography.
class _SectionPhoenix extends StatelessWidget {
  const _SectionPhoenix({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          ...AppShadows.card,
          BoxShadow(
            color: AppColors.accentGlow.withValues(alpha: 0.12),
            blurRadius: 28,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.sparkles,
                size: 28,
                color: AppColors.accent,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.journeyPhoenixTitle,
                  style: GoogleFonts.condiment(
                    fontSize: Breakpoints.isMobile(MediaQuery.sizeOf(context).width) ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.journeyPhoenixBody,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}

/// Three academy cards (BaZi Harmony, Feng Shui Charter, QiMen Dunjia) — same design as main page.
class _JourneyAcademyCards extends StatelessWidget {
  const _JourneyAcademyCards({required this.l10n, required this.isNarrow});

  final AppLocalizations l10n;
  final bool isNarrow;

  @override
  Widget build(BuildContext context) {
    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
  }
}
