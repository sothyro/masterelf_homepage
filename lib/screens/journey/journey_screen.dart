import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../utils/mobile_web_performance.dart';
import '../../widgets/academy_card.dart';
import '../../widgets/consultation_closing_cta.dart';
import '../../widgets/editorial_page_hero.dart';
import '../field_work/field_work_widgets.dart';
import '../home/widgets/field_work_chinese_design.dart';

/// Master Elf's Journey page: hero, story, Period 9, method bridge, and consultation path.
class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  final _storyKey = GlobalKey();

  void _scrollToStory() {
    final context = _storyKey.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    final isDesktop = Breakpoints.isDesktop(width);

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EditorialPageHero(
            isDesktop: isDesktop,
            backgroundAsset: AppContent.assetJourneyHero,
            backgroundCacheWidth:
                MobileWebPerformance.heroBackgroundCacheWidth(context),
            label: l10n.journeyPageHeadline,
            headline: l10n.journeyHeroSubline,
            body: l10n.journeyHeroBody,
            primaryCta: l10n.journeyHeroSpotlightCta,
            secondaryCta: l10n.journeyHeroMethodCta,
            onPrimary: _scrollToStory,
            onSecondary: () => context.push('/academy'),
            primaryIcon: LucideIcons.bookOpen,
            secondaryIcon: LucideIcons.compass,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: isNarrow ? 32 : 56,
              bottom: isNarrow ? 40 : 64,
              left: isNarrow ? 16 : 24,
              right: isNarrow ? 16 : 24,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KeyedSubtree(
                      key: _storyKey,
                      child: _SectionTheStory(l10n: l10n),
                    ),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _SectionPeriod9(l10n: l10n),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _SectionPhoenix(l10n: l10n),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _JourneyMethodBridge(l10n: l10n, isMobile: isNarrow),
                    SizedBox(height: isNarrow ? 40 : 56),
                    const FieldWorkJourneyTeaser(),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _JourneyAcademyCards(l10n: l10n),
                    SizedBox(height: isNarrow ? 40 : 56),
                    _JourneySocialProof(l10n: l10n, isMobile: isNarrow),
                    SizedBox(height: isNarrow ? 32 : 48),
                    ConsultationClosingCta(
                      heading: l10n.journeyClosingHeading,
                      body: l10n.journeyClosingBody,
                      isMobile: isNarrow,
                    ),
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
          style: highlightStyleForLocale(
            context,
            fontSize: isNarrow ? 26 : 32,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 28),
        _StoryCard(step: 1, text: l10n.journeyStory1),
        SizedBox(height: isNarrow ? 20 : 24),
        _StoryCard(step: 2, text: l10n.journeyStory2),
        SizedBox(height: isNarrow ? 20 : 24),
        _StoryCard(step: 3, text: l10n.journeyStory3),
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
                  style: highlightStyleForLocale(
                    context,
                    fontSize: Breakpoints.isMobile(MediaQuery.sizeOf(context).width)
                        ? 24
                        : 28,
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

class _JourneyMethodBridge extends StatelessWidget {
  const _JourneyMethodBridge({required this.l10n, required this.isMobile});

  final AppLocalizations l10n;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return FieldWorkChineseCtaPanel(
      isMobile: isMobile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MethodWaySeal(size: isMobile ? 36 : 44),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  l10n.journeyMethodBridgeTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 14 : 18),
          Text(
            l10n.journeyMethodBridgeBody,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.6,
                ),
          ),
          SizedBox(height: isMobile ? 18 : 24),
          FilledButton.icon(
            onPressed: () => context.push('/academy'),
            icon: const Icon(LucideIcons.compass, size: 18),
            label: Text(l10n.journeyMethodBridgeCta),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.onAccent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneySocialProof extends StatelessWidget {
  const _JourneySocialProof({required this.l10n, required this.isMobile});

  final AppLocalizations l10n;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceElevatedDark,
            AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.35)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.methodSocialProofTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.sectionKnowledgeBody,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.55,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.sectionKnowledgeBody2,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.55,
                ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
            ),
            child: Text(
              l10n.sectionKnowledgeStat,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.accentLight,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Three academy cards (BaZi, Feng Shui, QiMen) plus link to all six on The Method.
class _JourneyAcademyCards extends StatelessWidget {
  const _JourneyAcademyCards({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final isTablet = Breakpoints.isTabletOnly(width);

    final bazi = AcademyCard(
      icon: LucideIcons.user,
      title: l10n.methodPillarBaziTitle,
      description: l10n.methodPillarBaziHook,
      imageAsset: AppContent.assetBaziHarmony,
      onExplore: () => context.push('/consultations?service=bazi'),
    );
    final fengShui = AcademyCard(
      icon: LucideIcons.home,
      title: l10n.methodPillarFengShuiTitle,
      description: l10n.methodPillarFengShuiHook,
      imageAsset: AppContent.assetAcademyFengShui,
      onExplore: () => context.push('/consultations?service=fengshui'),
    );
    final qiMen = AcademyCard(
      icon: LucideIcons.compass,
      title: l10n.methodPillarQimenTitle,
      description: l10n.methodPillarQimenHook,
      imageAsset: AppContent.assetAcademyQiMen,
      onExplore: () => context.push('/consultations?service=qimeniching'),
    );

    final intro = Text(
      l10n.methodJourneyIntro,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.onSurfaceVariantDark,
            height: 1.55,
          ),
    );

    final viewAllLink = Align(
      alignment: isMobile ? Alignment.center : Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () => context.push('/academy'),
        icon: const Icon(LucideIcons.arrowRight, size: 18),
        label: Text(l10n.journeyViewAllSixConsultations),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
        ),
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          intro,
          const SizedBox(height: 24),
          bazi,
          const SizedBox(height: 20),
          fengShui,
          const SizedBox(height: 20),
          qiMen,
          const SizedBox(height: 16),
          viewAllLink,
        ],
      );
    }
    if (isTablet) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          intro,
          const SizedBox(height: 24),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: bazi),
                const SizedBox(width: 24),
                Expanded(child: fengShui),
              ],
            ),
          ),
          const SizedBox(height: 20),
          qiMen,
          const SizedBox(height: 16),
          viewAllLink,
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        intro,
        const SizedBox(height: 24),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: bazi),
              const SizedBox(width: 24),
              Expanded(child: fengShui),
              const SizedBox(width: 24),
              Expanded(child: qiMen),
            ],
          ),
        ),
        const SizedBox(height: 16),
        viewAllLink,
      ],
    );
  }
}
