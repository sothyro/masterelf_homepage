import 'package:flutter/material.dart';

import '../../config/app_content.dart';
import '../../config/field_work_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_asset_preloader.dart';
import '../../utils/breakpoints.dart';
import '../home/widgets/featured_in_consultation_band.dart';
import '../home/widgets/field_work_chinese_design.dart';
import '../store/widgets/store_page_hero.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      AppAssetPreloader.preloadFieldWorkSpotlightVideos(
        MediaQuery.sizeOf(context).width,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final isCompact = Breakpoints.isCompact(width);
    final languageCode = Localizations.localeOf(context).languageCode;
    final pillars = buildFieldWorkCoreActivities(l10n, languageCode);
    final videos = buildActivityVideoSpotlights(l10n);

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StorePageHero(
            title: l10n.fieldWorkPageTitle,
            description: l10n.fieldWorkPageSubline,
            descriptionHighlight: '',
            backgroundAsset: AppContent.assetActivitiesHero,
            heroHeightNarrow: 560,
            heroHeightWide: 500,
            titleContent: FieldWorkChineseSectionHeader(
              title: l10n.fieldWorkPageTitle,
              headline: l10n.fieldWorkPageSubline,
              subline: l10n.fieldWorkSectionSubline,
              isMobile: isMobile || isCompact,
            ),
          ),
          ActivitySpotlightSection(
            l10n: l10n,
            videos: videos,
            isMobile: isMobile || isCompact,
          ),
          FeaturedInConsultationBand(l10n: l10n),
          ActivityStoriesSection(
            l10n: l10n,
            pillars: pillars,
          ),
        ],
      ),
    );
  }
}
