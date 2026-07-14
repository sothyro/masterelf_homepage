import 'package:flutter/material.dart';

import '../../app_bootstrap.dart';
import '../../config/field_work_content.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/app_asset_preloader.dart';
import '../field_work/widgets/activity_stories_section.dart';
import 'widgets/hero_section.dart';
import 'widgets/events_section.dart';
import 'widgets/academies_section.dart';
import 'widgets/consultations_section.dart';
import 'widgets/field_work_section.dart';
import 'widgets/story_section.dart';
import 'widgets/featured_in_consultation_band.dart';
import 'widgets/cta_section.dart';
import 'widgets/testimonials_section.dart';

/// Builds every homepage section immediately. During cold start the bootstrap
/// loading overlay covers this screen until all sections are mounted and
/// painted ([HomeReadiness]), so the reveal never shows in-progress builds
/// and scrolling doesn't stutter from late-mounting widgets.
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
      HomeReadiness.markAllSectionsMounted();
      // Below-fold assets load only after the loader can dismiss, so they
      // never compete with first paint or hero video startup.
      HomeReadiness.ready.then((_) {
        AppAssetPreloader.preloadBelowFoldHomepage();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const RepaintBoundary(child: HeroSection()),
        const RepaintBoundary(child: EventsSection()),
        const RepaintBoundary(child: AcademiesSection()),
        const RepaintBoundary(child: ConsultationsSection()),
        const RepaintBoundary(child: FieldWorkSection()),
        const RepaintBoundary(child: StorySection()),
        RepaintBoundary(
          child: FeaturedInConsultationBand(
            l10n: l10n,
            showConsultationButton: false,
          ),
        ),
        RepaintBoundary(
          child: ActivityStoriesSection(
            l10n: l10n,
            heading: l10n.homeCoreActivitiesHeading,
            subline: l10n.homeCoreActivitiesSubline,
            pillars: buildFieldWorkCoreActivities(l10n, languageCode),
          ),
        ),
        const RepaintBoundary(child: TestimonialsSection()),
        const RepaintBoundary(child: CtaSection()),
      ],
    );
  }
}
