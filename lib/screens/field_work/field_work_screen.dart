import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../config/app_content.dart';
import '../../config/field_work_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_asset_preloader.dart';
import '../../utils/breakpoints.dart';
import '../../utils/mobile_web_performance.dart';
import '../../widgets/consultation_closing_cta.dart';
import '../../widgets/editorial_page_hero.dart';
import '../../widgets/viewport_deferred_section.dart';
import '../home/widgets/featured_in_consultation_band.dart';
import '../home/widgets/field_work_chinese_design.dart';
import 'field_work_load_coordinator.dart';
import 'widgets/activity_spotlight_section.dart';
import 'widgets/activity_stories_section.dart';

/// Activities hub: hero, 6 video spotlights, four core activities.
class FieldWorkScreen extends StatefulWidget {
  const FieldWorkScreen({
    super.key,
    this.initialRealm,
    this.initialVideosOnly = false,
  });

  final FieldWorkRealm? initialRealm;
  final bool initialVideosOnly;

  @override
  State<FieldWorkScreen> createState() => _FieldWorkScreenState();
}

class _FieldWorkScreenState extends State<FieldWorkScreen> {
  final _spotlightsKey = GlobalKey();
  final _storiesKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      FieldWorkLoadCoordinator.armAfterReveal(
        layoutWidth: MediaQuery.sizeOf(context).width,
      );
      if (widget.initialVideosOnly) {
        _scrollToSpotlights();
      } else if (widget.initialRealm != null) {
        _scrollToStories();
      }
    });
  }

  void _prewarmSpotlightVideos() {
    AppAssetPreloader.preloadFieldWorkSpotlightVideos(
      MediaQuery.sizeOf(context).width,
    );
  }

  void _scrollToSpotlights() {
    final context = _spotlightsKey.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  void _scrollToStories() {
    final context = _storiesKey.currentContext;
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
    final isCompact = Breakpoints.isCompact(width);
    final isDesktop = Breakpoints.isDesktop(width);
    final languageCode = Localizations.localeOf(context).languageCode;
    final pillars = buildFieldWorkCoreActivities(l10n, languageCode);
    final videos = buildActivityVideoSpotlights(l10n);

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            child: EditorialPageHero(
              isDesktop: isDesktop,
              backgroundAsset: AppContent.assetActivitiesHero,
              backgroundCacheWidth:
                  MobileWebPerformance.heroBackgroundCacheWidth(context),
              label: l10n.fieldWorkNav,
              headline: l10n.fieldWorkSectionHeadline,
              body: l10n.fieldWorkSectionSubline,
              primaryCta: l10n.methodClosingCta,
              secondaryCta: l10n.fieldWorkSeeRealSessionsLink,
              onPrimary: () => context.push('/consultations'),
              onSecondary: _scrollToSpotlights,
            ),
          ),
          ViewportDeferredSection(
            sectionKey: 'field-work-spotlights',
            placeholderHeight: isMobile ? 2800 : 3200,
            onNearViewport: _prewarmSpotlightVideos,
            child: RepaintBoundary(
              child: KeyedSubtree(
                key: _spotlightsKey,
                child: ActivitySpotlightSection(
                  l10n: l10n,
                  videos: videos,
                  isMobile: isMobile || isCompact,
                ),
              ),
            ),
          ),
          ViewportDeferredSection(
            sectionKey: 'field-work-featured',
            placeholderHeight: isMobile ? 320 : 400,
            child: RepaintBoundary(
              child: FeaturedInConsultationBand(l10n: l10n),
            ),
          ),
          RepaintBoundary(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 16 : 24,
                isMobile ? 32 : 48,
                isMobile ? 16 : 24,
                0,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: _FieldWorkMethodBridge(l10n: l10n, isMobile: isMobile),
                ),
              ),
            ),
          ),
          ViewportDeferredSection(
            sectionKey: 'field-work-stories',
            placeholderHeight: isMobile ? 720 : 900,
            child: RepaintBoundary(
              child: KeyedSubtree(
                key: _storiesKey,
                child: ActivityStoriesSection(
                  l10n: l10n,
                  pillars: pillars,
                  initialRealm: widget.initialRealm,
                  preloadOwnerKey: 'field-work-activity-stories',
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 16 : 24,
              isMobile ? 32 : 48,
              isMobile ? 16 : 24,
              isMobile ? 48 : 64,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: ConsultationClosingCta(
                  heading: l10n.fieldWorkClosingHeading,
                  body: l10n.fieldWorkClosingBody,
                  isMobile: isMobile,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldWorkMethodBridge extends StatelessWidget {
  const _FieldWorkMethodBridge({required this.l10n, required this.isMobile});

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
                  l10n.fieldWorkMethodBridgeTitle,
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
            l10n.fieldWorkMethodBridgeBody,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.6,
                ),
          ),
          SizedBox(height: isMobile ? 18 : 24),
          FilledButton.icon(
            onPressed: () => context.push('/academy'),
            icon: const Icon(LucideIcons.compass, size: 18),
            label: Text(l10n.fieldWorkMethodBridgeCta),
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
