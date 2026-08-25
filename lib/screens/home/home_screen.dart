import 'package:flutter/material.dart';

import '../../app_bootstrap.dart';
import '../../config/field_work_content.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/breakpoints.dart';
import '../field_work/widgets/activity_stories_section.dart';
import 'home_section_mount_queue.dart';
import 'widgets/hero_section.dart';
import 'widgets/events_section.dart';
import 'widgets/academies_section.dart';
import 'widgets/consultations_section.dart';
import 'widgets/field_work_section.dart';
import 'widgets/story_section.dart';
import 'widgets/featured_in_consultation_band.dart';
import 'widgets/cta_section.dart';
import 'widgets/testimonials_section.dart';
import 'widgets/home_queued_section.dart';

/// Homepage with tiered mounting: Hero + Events eager, then idle-time
/// progressive hydration of below-fold sections via [HomeSectionMountQueue].
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Eager tree is Hero + Events only; queue fills the rest on idle.
      // Background asset preload is armed from bootstrap dismiss (not here).
      HomeReadiness.markCriticalHomeContentReady();
      HomeSectionMountQueue.instance.armAfterCriticalReady();
    });
  }

  @override
  void dispose() {
    HomeReadiness.onHomeScreenDisposed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final pillars = buildFieldWorkCoreActivities(l10n, languageCode);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const RepaintBoundary(child: HeroSection()),
        const RepaintBoundary(child: EventsSection()),
        HomeQueuedSection(
          sectionKey: 'home-academies',
          placeholderHeight: isMobile ? 900 : 1100,
          child: const RepaintBoundary(child: AcademiesSection()),
        ),
        HomeQueuedSection(
          sectionKey: 'home-consultations',
          placeholderHeight: isMobile ? 720 : 900,
          child: const RepaintBoundary(child: ConsultationsSection()),
        ),
        HomeQueuedSection(
          sectionKey: 'home-field-work-story',
          placeholderHeight: isMobile ? 1400 : 1600,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RepaintBoundary(child: FieldWorkSection()),
              RepaintBoundary(child: StorySection()),
            ],
          ),
        ),
        HomeQueuedSection(
          sectionKey: 'home-featured-band',
          placeholderHeight: isMobile ? 320 : 400,
          child: RepaintBoundary(
            child: FeaturedInConsultationBand(
              l10n: l10n,
              showConsultationButton: false,
            ),
          ),
        ),
        HomeQueuedSection(
          sectionKey: 'home-activity-stories',
          placeholderHeight: isMobile ? 720 : 900,
          child: RepaintBoundary(
            child: ActivityStoriesSection(
              l10n: l10n,
              heading: l10n.homeCoreActivitiesHeading,
              subline: l10n.homeCoreActivitiesSubline,
              pillars: pillars,
              preloadOwnerKey: 'home-activity-stories',
            ),
          ),
        ),
        HomeQueuedSection(
          sectionKey: 'home-testimonials',
          placeholderHeight: isMobile ? 680 : 820,
          child: const RepaintBoundary(child: TestimonialsSection()),
        ),
        HomeQueuedSection(
          sectionKey: 'home-cta',
          placeholderHeight: isMobile ? 280 : 320,
          child: const RepaintBoundary(child: CtaSection()),
        ),
      ],
    );
  }
}
