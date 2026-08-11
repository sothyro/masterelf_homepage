import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../config/app_content.dart';
import '../../../config/events_data.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../utils/mobile_web_performance.dart';
import '../../home/widgets/field_work_chinese_design.dart';
import '../../store/widgets/description_with_highlight.dart';
import 'events_event_badges.dart';
import 'events_meta_chip.dart';

class EventsCompletedSpotlight extends StatefulWidget {
  const EventsCompletedSpotlight({
    super.key,
    required this.event,
    required this.l10n,
  });

  final EventItem event;
  final AppLocalizations l10n;

  @override
  State<EventsCompletedSpotlight> createState() =>
      _EventsCompletedSpotlightState();
}

class _EventsCompletedSpotlightState extends State<EventsCompletedSpotlight> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final event = widget.event;
    final l10n = widget.l10n;
    final borderColor = _hovered
        ? AppColors.accent.withValues(alpha: 0.55)
        : AppColors.borderDark;

    final imageBlock = ChineseCornerBrackets(
      length: isNarrow ? 16 : 20,
      inset: isNarrow ? 8 : 10,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              event.imageAsset,
              fit: BoxFit.cover,
              cacheWidth: MobileWebPerformance.cardImageCacheWidth(context, 640),
              filterQuality: MobileWebPerformance.imageFilterQuality(context),
              errorBuilder: (_, __, ___) => ColoredBox(
                color: AppColors.primary.withValues(alpha: 0.2),
                child: Icon(
                  LucideIcons.calendarDays,
                  size: 48,
                  color: AppColors.accent.withValues(alpha: 0.5),
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.45),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: EventsEventBadges(
                l10n: l10n,
                status: event.status,
                format: event.format,
              ),
            ),
          ],
        ),
      ),
    );

    final copyBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          event.subtitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.accentLight,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.eventsPhoenixRecapHook,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.45,
                fontStyle: FontStyle.italic,
              ),
        ),
        const SizedBox(height: 12),
        DescriptionWithHighlight(
          description: l10n.eventsPhoenixRecapBody,
          highlightPhrase: l10n.eventsPhoenixRecapHighlight,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            EventsMetaChip(icon: LucideIcons.calendar, label: event.date),
            EventsMetaChip(icon: LucideIcons.mapPin, label: event.location),
          ],
        ),
        const SizedBox(height: 18),
        OutlinedButton.icon(
          onPressed: () => context.push('/journey'),
          icon: const Icon(LucideIcons.bookOpen, size: 18),
          label: Text(l10n.eventsExploreJourney),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.accent,
            side: BorderSide(color: AppColors.accent.withValues(alpha: 0.5)),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: _hovered ? 1.5 : 1),
          boxShadow: _hovered ? AppShadows.eventCardHover : AppShadows.eventCard,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            imageBlock,
            const ChineseMountingBar(),
            Container(
              color: FieldWorkChinesePalette.inkWash.withValues(alpha: 0.72),
              padding: EdgeInsets.all(isNarrow ? 18 : 24),
              child: isNarrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        copyBlock,
                        const SizedBox(height: 22),
                        _VenuePartnerLogos(l10n: l10n),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: copyBlock),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 4,
                          child: _VenuePartnerLogos(l10n: l10n),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VenuePartnerLogos extends StatelessWidget {
  const _VenuePartnerLogos({required this.l10n});

  final AppLocalizations l10n;

  List<({String asset, String label})> get _logos => [
        (asset: AppContent.assetVenueChipmong, label: l10n.eventsVenueChipmong),
        (
          asset: AppContent.assetVenueLegendCinema,
          label: l10n.eventsVenueLegendCinema,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    final gap = isNarrow ? 12.0 : 14.0;

    return Row(
      key: const Key('events-venue-partners'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _logos.length; i++) ...[
          if (i > 0) SizedBox(width: gap),
          Expanded(
            child: _VenuePartnerCard(
              assetPath: _logos[i].asset,
              label: _logos[i].label,
            ),
          ),
        ],
      ],
    );
  }
}

class _VenuePartnerCard extends StatefulWidget {
  const _VenuePartnerCard({
    required this.assetPath,
    required this.label,
  });

  final String assetPath;
  final String label;

  @override
  State<_VenuePartnerCard> createState() => _VenuePartnerCardState();
}

class _VenuePartnerCardState extends State<_VenuePartnerCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(isNarrow ? 12 : 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.5)
                : AppColors.borderDark,
            width: _hovered ? 2 : 1,
          ),
          boxShadow: _hovered ? AppShadows.cardHover : AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  widget.assetPath,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  cacheWidth: MobileWebPerformance.cardImageCacheWidth(context, 120),
                  filterQuality: MobileWebPerformance.imageFilterQuality(context),
                  errorBuilder: (_, __, ___) => ColoredBox(
                    color: AppColors.borderDark,
                    child: Icon(
                      LucideIcons.image,
                      size: 32,
                      color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: isNarrow ? 10 : 12),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
