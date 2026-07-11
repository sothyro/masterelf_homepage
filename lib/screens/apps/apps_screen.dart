import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/apps_showcase_content.dart';
import '../../config/store_routes.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../widgets/app_shell_scroll_scope.dart';
import '../store/widgets/section_anchor.dart';
import '../store/widgets/store_content_container.dart';
import '../store/widgets/store_page_hero.dart';
import 'widgets/apps_chapter_header.dart';
import 'widgets/apps_chinese_page_shell.dart';
import 'widgets/apps_feature_gallery.dart';
import 'widgets/apps_hero_medallion.dart';
import 'widgets/apps_master_elf_system_intro.dart';
import 'widgets/apps_period9_section.dart';
import '../home/widgets/field_work_chinese_design.dart';

/// Apps page: Master Elf System and Period 9 Mobile App.
class AppsScreen extends StatefulWidget {
  const AppsScreen({super.key});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  final GlobalKey _keyMasterElf = GlobalKey();
  final GlobalKey _keyPeriod9 = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollToSectionIfNeeded();
  }

  void _scrollToSectionIfNeeded() {
    final fragment = GoRouterState.of(context).uri.fragment;
    if (fragment.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final key = switch (fragment) {
        kAppsMasterElfFragment => _keyMasterElf,
        kAppsPeriod9Fragment => _keyPeriod9,
        _ => null,
      };
      if (key != null) {
        ensureShellSectionVisible(context, key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final groups = buildAppsShowcaseGroups(l10n);

    return Material(
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StorePageHero(
            title: '',
            description: '',
            descriptionHighlight: '',
            titleContent: const AppsHeroMedallion(),
            heroHeightNarrow: 477,
            heroHeightWide: 477,
          ),
          AppsChinesePageShell(
            child: StoreContentContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  SectionAnchor(
                    key: _keyMasterElf,
                    child: AppsMasterElfSystemIntro(l10n: l10n),
                  ),
                  SizedBox(height: isMobile ? 28 : 36),
                  AppsFeatureGallery(
                    groups: groups,
                    overviewPlatformsLabel: l10n.appsGroupOverviewPlatforms,
                    includeGroupIds: const {'overview'},
                  ),
                  const SizedBox(height: 48),
                  const ChineseMountingBar(),
                  const SizedBox(height: 48),
                  AppsChapterHeader(
                    title: l10n.appsChapterPeriod9Mobile,
                    isMobile: isMobile,
                    sealCharacter: '运',
                  ),
                  const SizedBox(height: 32),
                  SectionAnchor(
                    key: _keyPeriod9,
                    child: AppsPeriod9Section(l10n: l10n),
                  ),
                  SizedBox(height: isMobile ? 48 : 56),
                  const ChineseMountingBar(),
                  SizedBox(height: isMobile ? 40 : 48),
                  AppsChapterHeader(
                    title: l10n.appsChapterFeatureAtlas,
                    headline: l10n.appsChapterFeatureAtlasHeadline,
                    subline: l10n.appsChapterFeatureAtlasSubline,
                    isMobile: isMobile,
                    sealCharacter: '卦',
                  ),
                  const SizedBox(height: 32),
                  AppsFeatureGallery(
                    groups: groups,
                    overviewPlatformsLabel: l10n.appsGroupOverviewPlatforms,
                    excludeGroupIds: const {'overview'},
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
