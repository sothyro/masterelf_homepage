import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../config/field_work_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../home/widgets/field_work_chinese_design.dart';
import '../field_work_widgets.dart';
import 'activity_video_playback_hub.dart';
import 'activity_video_player.dart';

/// Six alternating 9:16 video spotlight rows on modern Chinese background.
class ActivitySpotlightSection extends StatefulWidget {
  const ActivitySpotlightSection({
    super.key,
    required this.l10n,
    required this.videos,
    required this.isMobile,
  });

  final AppLocalizations l10n;
  final List<ActivityVideoSpotlight> videos;
  final bool isMobile;

  @override
  State<ActivitySpotlightSection> createState() => _ActivitySpotlightSectionState();
}

class _ActivitySpotlightSectionState extends State<ActivitySpotlightSection> {
  final _playbackHub = ActivityVideoPlaybackHub();

  @override
  Widget build(BuildContext context) {
    final paddingH = widget.isMobile ? 16.0 : 24.0;
    final verticalPad = widget.isMobile ? 48.0 : 64.0;

    return ActivityVideoPlaybackScope(
      hub: _playbackHub,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(child: ChineseInkWashGlow()),
          Padding(
            padding: EdgeInsets.fromLTRB(paddingH, verticalPad, paddingH, verticalPad),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FieldWorkChineseSectionHeader(
                      title: widget.l10n.fieldWorkVideosHeading,
                      subline: widget.l10n.fieldWorkVideosSubline,
                      isMobile: widget.isMobile,
                      centerEmblem: FieldWorkVideoEmblem(
                        size: widget.isMobile ? 40 : 48,
                      ),
                    ),
                    SizedBox(height: widget.isMobile ? 36 : 48),
                    for (var i = 0; i < widget.videos.length; i++)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: i < widget.videos.length - 1
                              ? (widget.isMobile ? 24 : 32)
                              : 0,
                        ),
                        child: _SpotlightRow(
                          video: widget.videos[i],
                          l10n: widget.l10n,
                          index: i,
                          reverse: !widget.isMobile && i.isOdd,
                          isMobile: widget.isMobile,
                        ),
                      ),
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

class _SpotlightRow extends StatefulWidget {
  const _SpotlightRow({
    required this.video,
    required this.l10n,
    required this.index,
    required this.reverse,
    required this.isMobile,
  });

  final ActivityVideoSpotlight video;
  final AppLocalizations l10n;
  final int index;
  final bool reverse;
  final bool isMobile;

  @override
  State<_SpotlightRow> createState() => _SpotlightRowState();
}

class _SpotlightRowState extends State<_SpotlightRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final video = widget.video;
    final servicePath = video.consultationPath();

    final videoFrame = MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: ChineseCornerBrackets(
        color: _hovered
            ? AppColors.accent
            : AppColors.accent.withValues(alpha: 0.45),
        length: widget.isMobile ? 14 : 18,
        inset: widget.isMobile ? 8 : 10,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hovered
                  ? AppColors.accent.withValues(alpha: 0.65)
                  : AppColors.borderDark,
              width: _hovered ? 2 : 1,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accentGlow.withValues(alpha: 0.22),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : AppShadows.card,
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push(video.detailPath()),
              child: Stack(
                children: [
                  ActivityVideoPlayer(
                    playbackId: video.id,
                    autoplayWhenVisible: true,
                    videoAsset: video.videoAsset,
                    posterImage: video.posterImage,
                    borderRadius: 18,
                    maxWidth: widget.isMobile ? null : 340,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: ChinesePillarIndexTag(
                      index: widget.index,
                      accentColor: realmColor(video.realm),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: ChineseRealmSeal(
                      icon: fieldWorkRealmIcon(video.realm),
                      accentColor: realmColor(video.realm),
                      indexLabel: ChineseRealmSeal.labelForIndex(widget.index),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final copyPanel = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldWorkRealmBadge(realm: video.realm, l10n: widget.l10n),
        const SizedBox(height: 14),
        Container(
          width: 36,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.accent,
                realmColor(video.realm),
              ],
            ),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          video.title,
          style: highlightStyleForLocale(
            context,
            fontSize: widget.isMobile ? 22 : 26,
            fontWeight: FontWeight.w700,
            color: FieldWorkChinesePalette.ricePaper.withValues(alpha: 0.98),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          video.subtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.92),
                height: 1.45,
              ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => context.push(video.detailPath()),
              icon: const Icon(LucideIcons.play, size: 18),
              label: Text(widget.l10n.fieldWorkWatchVideo),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            if (servicePath != null)
              OutlinedButton.icon(
                onPressed: () => context.push(servicePath),
                icon: const Icon(LucideIcons.calendarCheck, size: 18),
                label: Text(widget.l10n.fieldWorkRelatedService),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: BorderSide(color: AppColors.accent.withValues(alpha: 0.75)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ],
    );

    final rowContent = widget.isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              videoFrame,
              const SizedBox(height: 20),
              copyPanel,
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.reverse
                ? [
                    Expanded(child: copyPanel),
                    const SizedBox(width: 40),
                    videoFrame,
                  ]
                : [
                    videoFrame,
                    const SizedBox(width: 40),
                    Expanded(child: copyPanel),
                  ],
          );

    // Text side gets ink-wash fade from its outer edge toward the row centre only.
    // Video side stays transparent over the section background.
    final fadeOverlay = widget.isMobile
        ? LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              FieldWorkChinesePalette.inkWash.withValues(alpha: 0.88),
              FieldWorkChinesePalette.inkWash.withValues(alpha: 0),
            ],
          )
        : widget.reverse
            ? LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.center,
                colors: [
                  FieldWorkChinesePalette.inkWash.withValues(alpha: 0.88),
                  FieldWorkChinesePalette.inkWash.withValues(alpha: 0),
                ],
              )
            : LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.center,
                colors: [
                  FieldWorkChinesePalette.inkWash.withValues(alpha: 0.88),
                  FieldWorkChinesePalette.inkWash.withValues(alpha: 0),
                ],
              );

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(gradient: fadeOverlay),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(widget.isMobile ? 16 : 24),
            child: rowContent,
          ),
        ],
      ),
    );
  }
}
