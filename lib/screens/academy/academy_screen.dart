import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../config/app_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../widgets/consultation_closing_cta.dart';
import '../home/widgets/field_work_chinese_design.dart';
import '../store/widgets/store_page_hero.dart';

/// The Method — consultation-first introduction to Master Elf's integrated system.
class AcademyScreen extends StatefulWidget {
  const AcademyScreen({super.key});

  @override
  State<AcademyScreen> createState() => _AcademyScreenState();
}

class _AcademyScreenState extends State<AcademyScreen> {
  final _pillarsKey = GlobalKey();

  void _scrollToPillars() {
    final context = _pillarsKey.currentContext;
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
    final isMobile = Breakpoints.isMobile(width);
    final isTablet = Breakpoints.isTabletOnly(width);
    final isDesktop = Breakpoints.isDesktop(width);
    final pillars = _methodPillars(l10n);

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MethodHero(
            isDesktop: isDesktop,
            l10n: l10n,
            onViewConsultationTypes: _scrollToPillars,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 32,
              vertical: isMobile ? 32 : 40,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _MethodWhyConsultSection(l10n: l10n, isMobile: isMobile),
                    SizedBox(height: isMobile ? 32 : 48),
                    _MethodSystemSection(l10n: l10n, isMobile: isMobile),
                    SizedBox(height: isMobile ? 32 : 48),
                    KeyedSubtree(
                      key: _pillarsKey,
                      child: _MethodPillarsSection(
                        l10n: l10n,
                        pillars: pillars,
                        isMobile: isMobile,
                        isTablet: isTablet,
                      ),
                    ),
                    SizedBox(height: isMobile ? 32 : 48),
                    _MethodSessionSteps(l10n: l10n, isMobile: isMobile),
                    SizedBox(height: isMobile ? 32 : 48),
                    _MethodSocialProof(l10n: l10n, isMobile: isMobile),
                    SizedBox(height: isMobile ? 32 : 48),
                    ConsultationClosingCta(
                      heading: l10n.notSureWhereToStart,
                      body: l10n.methodNotSureBody,
                      isMobile: isMobile,
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

  List<_MethodPillar> _methodPillars(AppLocalizations l10n) {
    return [
      _MethodPillar(
        imageAsset: AppContent.assetBaziHarmony,
        icon: LucideIcons.user,
        title: l10n.methodPillarBaziTitle,
        hook: l10n.methodPillarBaziHook,
        topics: l10n.methodPillarBaziTopics,
        serviceId: 'bazi',
        imageAlignment: Alignment.center,
      ),
      _MethodPillar(
        imageAsset: AppContent.assetAcademyFengShui,
        icon: LucideIcons.home,
        title: l10n.methodPillarFengShuiTitle,
        hook: l10n.methodPillarFengShuiHook,
        topics: l10n.methodPillarFengShuiTopics,
        serviceId: 'fengshui',
      ),
      _MethodPillar(
        imageAsset: AppContent.assetAcademyQiMen,
        icon: LucideIcons.compass,
        title: l10n.methodPillarQimenTitle,
        hook: l10n.methodPillarQimenHook,
        topics: l10n.methodPillarQimenTopics,
        serviceId: 'qimeniching',
        imageAlignment: Alignment.center,
      ),
      _MethodPillar(
        imageAsset: AppContent.assetEventCard,
        icon: LucideIcons.calendarDays,
        title: l10n.methodPillarDateSelectionTitle,
        hook: l10n.methodPillarDateSelectionHook,
        topics: l10n.methodPillarDateSelectionTopics,
        serviceId: 'dateselection',
      ),
      _MethodPillar(
        imageAsset: AppContent.assetAppsHero,
        icon: LucideIcons.bookOpen,
        title: l10n.methodPillarIchingTitle,
        hook: l10n.methodPillarIchingHook,
        topics: l10n.methodPillarIchingTopics,
        serviceId: 'qimeniching',
      ),
      _MethodPillar(
        imageAsset: AppContent.assetEventMain,
        icon: LucideIcons.mountain,
        title: l10n.methodPillarMaoshanTitle,
        hook: l10n.methodPillarMaoshanHook,
        topics: l10n.methodPillarMaoshanTopics,
        serviceId: 'maosan',
      ),
    ];
  }
}

class _MethodPillar {
  const _MethodPillar({
    required this.imageAsset,
    required this.icon,
    required this.title,
    required this.hook,
    required this.topics,
    required this.serviceId,
    this.imageAlignment,
  });

  final String imageAsset;
  final IconData icon;
  final String title;
  final String hook;
  final String topics;
  final String serviceId;
  final Alignment? imageAlignment;
}

class _MethodHero extends StatelessWidget {
  const _MethodHero({
    required this.isDesktop,
    required this.l10n,
    required this.onViewConsultationTypes,
  });

  final bool isDesktop;
  final AppLocalizations l10n;
  final VoidCallback onViewConsultationTypes;

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return SizedBox(
        height: 720,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Image.asset(
                AppContent.assetJourneyHero,
                fit: BoxFit.cover,
                alignment: const Alignment(0.15, 0.0),
                errorBuilder: (_, __, ___) => const SizedBox.expand(),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.backgroundDark.withValues(alpha: 0.42),
                      Colors.transparent,
                      AppColors.backgroundDark.withValues(alpha: 0.35),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(-0.75, -0.35),
                    radius: 1.05,
                    colors: [
                      AppColors.accent.withValues(alpha: 0.16),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.backgroundDark.withValues(alpha: 0.94),
                      AppColors.backgroundDark.withValues(alpha: 0.62),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.42, 0.82],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: ChineseLatticePainter(opacity: 0.045, cellSize: 72),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: ChineseCornerBrackets(
                  length: 40,
                  inset: 28,
                  strokeWidth: 1.4,
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            Positioned(
              left: 48,
              bottom: 56,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: ChineseCornerBrackets(
                  length: 26,
                  inset: 14,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: FieldWorkChinesePalette.inkWash.withValues(alpha: 0.82),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentGlow.withValues(alpha: 0.18),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 26, 28, 28),
                      child: _MethodHeroCopy(
                        l10n: l10n,
                        isMobile: false,
                        onViewConsultationTypes: onViewConsultationTypes,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final isMobile = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    return StorePageHero(
      title: l10n.methodPageTitle,
      description: l10n.methodHeroHeadline,
      descriptionHighlight: '',
      backgroundAsset: AppContent.assetAppsHero,
      heroHeightNarrow: isMobile ? 540 : 520,
      heroHeightWide: 520,
      titleContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FieldWorkChineseSectionHeader(
            title: l10n.methodPageTitle,
            headline: l10n.methodHeroHeadline,
            subline: l10n.methodHeroSubline,
            isMobile: isMobile,
            centerEmblem: MethodWaySeal(size: isMobile ? 38 : 44),
          ),
          const SizedBox(height: 24),
          _MethodHeroActions(
            l10n: l10n,
            stacked: true,
            onViewConsultationTypes: onViewConsultationTypes,
          ),
        ],
      ),
    );
  }
}

class _MethodHeroCopy extends StatelessWidget {
  const _MethodHeroCopy({
    required this.l10n,
    required this.isMobile,
    required this.onViewConsultationTypes,
  });

  final AppLocalizations l10n;
  final bool isMobile;
  final VoidCallback onViewConsultationTypes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const MethodWaySeal(size: 52),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                l10n.methodPageTitle,
                style: highlightStyleForLocale(
                  context,
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const ChineseJewelLine(width: 200),
        const SizedBox(height: 18),
        Text(
          l10n.methodHeroHeadline,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: FieldWorkChinesePalette.ricePaper.withValues(alpha: 0.95),
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.methodHeroSubline,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: FieldWorkChinesePalette.ricePaper.withValues(alpha: 0.88),
                height: 1.55,
                fontSize: 17,
              ),
        ),
        const SizedBox(height: 24),
        _MethodHeroActions(
          l10n: l10n,
          stacked: false,
          onViewConsultationTypes: onViewConsultationTypes,
        ),
      ],
    );
  }
}

class _MethodHeroActions extends StatelessWidget {
  const _MethodHeroActions({
    required this.l10n,
    required this.stacked,
    required this.onViewConsultationTypes,
  });

  final AppLocalizations l10n;
  final bool stacked;
  final VoidCallback onViewConsultationTypes;

  @override
  Widget build(BuildContext context) {
    final primary = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: AppShadows.accentButton,
      ),
      child: FilledButton.icon(
        onPressed: () => context.push('/consultations'),
        icon: const Icon(LucideIcons.calendarCheck, size: 20),
        label: Text(l10n.methodHeroPrimaryCta),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.onAccent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: 0,
        ),
      ),
    );

    final secondary = TextButton.icon(
      onPressed: onViewConsultationTypes,
      icon: const Icon(LucideIcons.layers, size: 18),
      label: Text(l10n.methodHeroSecondaryCta),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accentLight,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );

    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          primary,
          const SizedBox(height: 8),
          Center(child: secondary),
        ],
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [primary, secondary],
    );
  }
}

class _MethodWhyConsultSection extends StatelessWidget {
  const _MethodWhyConsultSection({required this.l10n, required this.isMobile});

  final AppLocalizations l10n;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return FieldWorkChineseCtaPanel(
      isMobile: isMobile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.methodWhyConsultTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.methodWhyConsultBody,
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

class _MethodSystemSection extends StatelessWidget {
  const _MethodSystemSection({required this.l10n, required this.isMobile});

  final AppLocalizations l10n;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.methodSystemTitle,
          style: highlightStyleForLocale(
            context,
            fontSize: isMobile ? 26 : 32,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.methodSystemBody,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.65,
                fontSize: isMobile ? 15 : 17,
              ),
        ),
      ],
    );
  }
}

class _MethodPillarsSection extends StatelessWidget {
  const _MethodPillarsSection({
    required this.l10n,
    required this.pillars,
    required this.isMobile,
    required this.isTablet,
  });

  final AppLocalizations l10n;
  final List<_MethodPillar> pillars;
  final bool isMobile;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.methodPillarsTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.methodPillarsSubline,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.55,
              ),
        ),
        const SizedBox(height: 28),
        if (isMobile)
          Column(
            children: [
              for (var i = 0; i < pillars.length; i++) ...[
                if (i > 0) const SizedBox(height: 24),
                _MethodPillarCard(
                  pillar: pillars[i],
                  l10n: l10n,
                  isMobile: true,
                ),
              ],
            ],
          )
        else if (isTablet)
          Column(
            children: [
              for (var row = 0; row < pillars.length; row += 2) ...[
                if (row > 0) const SizedBox(height: 24),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _MethodPillarCard(
                          pillar: pillars[row],
                          l10n: l10n,
                          isMobile: false,
                        ),
                      ),
                      if (row + 1 < pillars.length) ...[
                        const SizedBox(width: 24),
                        Expanded(
                          child: _MethodPillarCard(
                            pillar: pillars[row + 1],
                            l10n: l10n,
                            isMobile: false,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          )
        else
          Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < 3; i++) ...[
                      if (i > 0) const SizedBox(width: 24),
                      Expanded(
                        child: _MethodPillarCard(
                          pillar: pillars[i],
                          l10n: l10n,
                          isMobile: false,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 3; i < 6; i++) ...[
                      if (i > 3) const SizedBox(width: 24),
                      Expanded(
                        child: _MethodPillarCard(
                          pillar: pillars[i],
                          l10n: l10n,
                          isMobile: false,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _MethodPillarCard extends StatefulWidget {
  const _MethodPillarCard({
    required this.pillar,
    required this.l10n,
    required this.isMobile,
  });

  final _MethodPillar pillar;
  final AppLocalizations l10n;
  final bool isMobile;

  @override
  State<_MethodPillarCard> createState() => _MethodPillarCardState();
}

class _MethodPillarCardState extends State<_MethodPillarCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final shadow = _hovered ? AppShadows.cardHover : AppShadows.card;
    final borderColor = _hovered
        ? AppColors.borderLight.withValues(alpha: 0.5)
        : AppColors.borderDark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: shadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push(
                '/consultations?service=${widget.pillar.serviceId}',
              ),
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: AspectRatio(
                      aspectRatio: widget.isMobile ? 1 : 16 / 9,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            widget.pillar.imageAsset,
                            fit: BoxFit.cover,
                            alignment: widget.pillar.imageAlignment ?? Alignment.topCenter,
                            errorBuilder: (_, __, ___) => ColoredBox(
                              color: AppColors.accent.withValues(alpha: 0.12),
                              child: Icon(
                                widget.pillar.icon,
                                size: 48,
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundDark.withValues(alpha: 0.75),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.borderLight.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Icon(
                                widget.pillar.icon,
                                size: 20,
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.pillar.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.onPrimary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.pillar.hook,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.accentLight.withValues(alpha: 0.92),
                                height: 1.45,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(LucideIcons.sparkles, size: 12, color: AppColors.accent),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                widget.pillar.topics,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.onSurfaceVariantDark,
                                      height: 1.35,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.l10n.methodPillarCta,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const Icon(Icons.arrow_forward, size: 16, color: AppColors.accent),
                          ],
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

class _MethodSessionSteps extends StatelessWidget {
  const _MethodSessionSteps({required this.l10n, required this.isMobile});

  final AppLocalizations l10n;
  final bool isMobile;

  static final _icons = [
    LucideIcons.messageCircle,
    LucideIcons.scan,
    LucideIcons.compass,
    LucideIcons.arrowRight,
  ];

  @override
  Widget build(BuildContext context) {
    final steps = [
      (l10n.methodSessionStep1Title, l10n.methodSessionStep1Body),
      (l10n.methodSessionStep2Title, l10n.methodSessionStep2Body),
      (l10n.methodSessionStep3Title, l10n.methodSessionStep3Body),
      (l10n.methodSessionStep4Title, l10n.methodSessionStep4Body),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.methodSessionTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 24),
        if (isMobile)
          Column(
            children: [
              for (var i = 0; i < steps.length; i++) ...[
                if (i > 0) const SizedBox(height: 16),
                _SessionStepTile(
                  index: i + 1,
                  icon: _icons[i],
                  title: steps[i].$1,
                  body: steps[i].$2,
                ),
              ],
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < steps.length; i++) ...[
                if (i > 0) const SizedBox(width: 20),
                Expanded(
                  child: _SessionStepTile(
                    index: i + 1,
                    icon: _icons[i],
                    title: steps[i].$1,
                    body: steps[i].$2,
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }
}

class _SessionStepTile extends StatelessWidget {
  const _SessionStepTile({
    required this.index,
    required this.icon,
    required this.title,
    required this.body,
  });

  final int index;
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.6)),
                  color: AppColors.accent.withValues(alpha: 0.12),
                ),
                child: Icon(icon, size: 16, color: AppColors.accent),
              ),
              const SizedBox(width: 10),
              Text(
                '$index',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}

class _MethodSocialProof extends StatelessWidget {
  const _MethodSocialProof({required this.l10n, required this.isMobile});

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
