import 'package:flutter/material.dart';

import '../../../config/apps_showcase_content.dart';
import '../../../utils/breakpoints.dart';
import 'apps_feature_ecosystem_stage.dart';
import 'apps_feature_spotlight_card.dart';
import 'apps_feature_strip.dart';

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
        final isDesktop = Breakpoints.isDesktop(width);
        final singleGroups = visibleGroups
            .where((g) => g.layout == AppsGroupLayout.single)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final group in visibleGroups) ...[
              if (group.layout == AppsGroupLayout.ecosystem) ...[
                AppsFeatureEcosystemStage(
                  platformsLabel: overviewPlatformsLabel,
                  asset: group.assets.first,
                  heroVideoAsset: group.heroVideoAsset,
                ),
                SizedBox(height: isMobile ? 36 : 48),
              ] else if (group.layout == AppsGroupLayout.strip ||
                  group.layout == AppsGroupLayout.triptych) ...[
                AppsFeatureStrip(
                  title: group.title,
                  benefit: group.benefit,
                  assets: group.assets,
                  deviceType: group.preferredDevice,
                  layout: group.layout,
                ),
                SizedBox(height: isMobile ? 36 : 48),
              ],
            ],
            if (singleGroups.isNotEmpty) ...[
              if (isDesktop)
                _SingleSpotlightGrid(groups: singleGroups)
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < singleGroups.length; i++) ...[
                      AppsFeatureSpotlightCard(
                        title: singleGroups[i].title,
                        benefit: singleGroups[i].benefit,
                        asset: singleGroups[i].assets.first,
                        deviceType: singleGroups[i].preferredDevice,
                      ),
                      if (i < singleGroups.length - 1)
                        SizedBox(height: isMobile ? 32 : 40),
                    ],
                  ],
                ),
            ],
          ],
        );
      },
    );
  }
}

class _SingleSpotlightGrid extends StatelessWidget {
  const _SingleSpotlightGrid({required this.groups});

  final List<AppsFeatureGroup> groups;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < groups.length; i += 2) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppsFeatureSpotlightCard(
                  title: groups[i].title,
                  benefit: groups[i].benefit,
                  asset: groups[i].assets.first,
                  deviceType: groups[i].preferredDevice,
                ),
              ),
              if (i + 1 < groups.length) ...[
                const SizedBox(width: 24),
                Expanded(
                  child: AppsFeatureSpotlightCard(
                    title: groups[i + 1].title,
                    benefit: groups[i + 1].benefit,
                    asset: groups[i + 1].assets.first,
                    deviceType: groups[i + 1].preferredDevice,
                  ),
                ),
              ],
            ],
          ),
          if (i + 2 < groups.length) const SizedBox(height: 40),
        ],
      ],
    );
  }
}
