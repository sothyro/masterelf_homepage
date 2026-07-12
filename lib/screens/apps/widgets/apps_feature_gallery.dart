import 'package:flutter/material.dart';

import '../../../config/apps_showcase_content.dart';
import '../../../utils/breakpoints.dart';
import 'apps_feature_carousel_stage.dart';
import 'apps_feature_ecosystem_stage.dart';

/// Renders [AppsFeatureGroup]s for the Apps page (full atlas or filtered subset).
class AppsFeatureGallery extends StatelessWidget {
  const AppsFeatureGallery({
    super.key,
    required this.groups,
    required this.overviewPlatformsLabel,
    this.includeGroupIds,
    this.excludeGroupIds,
  }) : assert(
          includeGroupIds == null || excludeGroupIds == null,
          'Use either includeGroupIds or excludeGroupIds, not both.',
        );

  final List<AppsFeatureGroup> groups;
  final String overviewPlatformsLabel;
  final Set<String>? includeGroupIds;
  final Set<String>? excludeGroupIds;

  List<AppsFeatureGroup> get _visibleGroups {
    if (includeGroupIds != null) {
      return groups.where((g) => includeGroupIds!.contains(g.id)).toList();
    }
    if (excludeGroupIds != null) {
      return groups.where((g) => !excludeGroupIds!.contains(g.id)).toList();
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final visibleGroups = _visibleGroups;
    if (visibleGroups.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < Breakpoints.mobile;
        final ecosystemGroups = visibleGroups
            .where((g) => g.layout == AppsGroupLayout.ecosystem)
            .toList();
        final moduleGroups = visibleGroups
            .where((g) => g.layout != AppsGroupLayout.ecosystem)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final group in ecosystemGroups) ...[
              AppsFeatureEcosystemStage(
                platformsLabel: overviewPlatformsLabel,
                asset: group.assets.first,
                heroVideoAsset: group.heroVideoAsset,
              ),
              if (moduleGroups.isNotEmpty)
                SizedBox(height: isMobile ? 36 : 48),
            ],
            if (moduleGroups.isNotEmpty)
              AppsFeatureCarouselStage(modules: moduleGroups),
          ],
        );
      },
    );
  }
}
