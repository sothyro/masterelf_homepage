import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../config/events_data.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../home/widgets/field_work_chinese_design.dart';
import '../../store/widgets/description_with_highlight.dart';
import 'events_upcoming_3d_frame.dart';
import 'events_event_badges.dart';
import 'events_meta_chip.dart';
import 'events_zodiac_calendar_strip.dart';

class EventsUpcomingSpotlight extends StatefulWidget {
  const EventsUpcomingSpotlight({
    super.key,
    required this.event,
    required this.l10n,
    required this.onRegister,
  });

  final EventItem event;
  final AppLocalizations l10n;
  final VoidCallback onRegister;

  @override
  State<EventsUpcomingSpotlight> createState() =>
      _EventsUpcomingSpotlightState();
}

class _EventsUpcomingSpotlightState extends State<EventsUpcomingSpotlight> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < Breakpoints.mobile;
        final event = widget.event;
        final l10n = widget.l10n;

        final orbitalStage = _OrbitalVisualStage(
          hovered: _hovered,
          isNarrow: isNarrow,
          imageAsset: event.imageAsset,
          limitedSeats: event.limitedSeats,
          l10n: l10n,
          event: event,
        );

        final detailsPanel = _UpcomingDetailsPanel(
          event: event,
          l10n: l10n,
          isNarrow: isNarrow,
          stretchCta: !isNarrow && constraints.hasBoundedHeight,
          onRegister: widget.onRegister,
        );

        return MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            clipBehavior: Clip.none,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isNarrow ? 20 : 24),
              border: Border.all(
                color: _hovered
                    ? AppColors.accent.withValues(alpha: 0.55)
                    : AppColors.borderDark,
                width: _hovered ? 1.5 : 1,
              ),
              boxShadow: _hovered ? AppShadows.eventCardHover : AppShadows.card,
            ),
            child: isNarrow || !constraints.hasBoundedHeight
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      orbitalStage,
                      const ChineseMountingBar(),
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                        child: detailsPanel,
                      ),
                    ],
                  )
                : IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 12, child: orbitalStage),
                        Container(
                          width: 1,
                          color: AppColors.borderDark.withValues(alpha: 0.85),
                        ),
                        Expanded(
                          flex: 10,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(24),
                            ),
                            child: detailsPanel,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

/// Dedicated stage so orbital rings have room to breathe and stay prominent.
class _OrbitalVisualStage extends StatelessWidget {
  const _OrbitalVisualStage({
    required this.hovered,
    required this.isNarrow,
    required this.imageAsset,
    required this.limitedSeats,
    required this.l10n,
    required this.event,
  });

  final bool hovered;
  final bool isNarrow;
  final String imageAsset;
  final bool limitedSeats;
  final AppLocalizations l10n;
  final EventItem event;

  @override
  Widget build(BuildContext context) {
    final horizontalRingPad = isNarrow ? 24.0 : 44.0;
    final verticalRingPad = isNarrow ? 32.0 : 40.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalRingPad,
        verticalRingPad,
        horizontalRingPad,
        isNarrow ? verticalRingPad : verticalRingPad + 12,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.05),
            radius: 1.15,
            colors: [
              AppColors.accentGlow.withValues(alpha: hovered ? 0.22 : 0.14),
              const Color(0xFF1E1408).withValues(alpha: 0.55),
              FieldWorkChinesePalette.inkWash,
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
          borderRadius: BorderRadius.circular(isNarrow ? 16 : 20),
        ),
        child: Padding(
          padding: EdgeInsets.all(isNarrow ? 12 : 16),
          child: EventsUpcoming3DFrame(
            imageAsset: imageAsset,
            aspectRatio: 16 / 9,
            hovered: hovered,
            topLeft: EventsEventBadges(
              l10n: l10n,
              status: event.status,
              format: event.format,
            ),
            topRight: limitedSeats
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent,
                          AppColors.accentLight.withValues(alpha: 0.95),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentGlow.withValues(alpha: 0.45),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      l10n.limitedSeats,
                      style: const TextStyle(
                        color: AppColors.onAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

/// Copy, meta, timeline, and CTA — title lives in the section header above.
class _UpcomingDetailsPanel extends StatelessWidget {
  const _UpcomingDetailsPanel({
    required this.event,
    required this.l10n,
    required this.isNarrow,
    required this.stretchCta,
    required this.onRegister,
  });

  final EventItem event;
  final AppLocalizations l10n;
  final bool isNarrow;
  final bool stretchCta;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    final padding = isNarrow ? 20.0 : 28.0;

    return Container(
      color: FieldWorkChinesePalette.inkWash.withValues(alpha: 0.78),
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            event.subtitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.28),
              ),
            ),
            child: Text(
              event.hook,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.accentLight.withValues(alpha: 0.95),
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
            ),
          ),
          const SizedBox(height: 18),
          DescriptionWithHighlight(
            description: event.description,
            highlightPhrase: l10n.eventsGoat2027DescriptionHighlight,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 20),
          const _GoldRule(),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              EventsMetaChip(icon: LucideIcons.calendar, label: event.date),
              EventsMetaChip(icon: LucideIcons.mapPin, label: event.location),
            ],
          ),
          const SizedBox(height: 20),
          EventsZodiacCalendarStrip(l10n: l10n),
          if (stretchCta) const Spacer(),
          SizedBox(height: isNarrow ? 24 : 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onRegister,
              icon: const Icon(LucideIcons.userPlus, size: 20),
              label: Text(l10n.registerForEvent),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoldRule extends StatelessWidget {
  const _GoldRule();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.accent,
                AppColors.accentLight.withValues(alpha: 0.4),
              ],
            ),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.borderDark.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}
