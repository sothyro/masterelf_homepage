import 'package:flutter/material.dart';

import '../../../config/events_data.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../home/widgets/field_work_chinese_design.dart';
import 'events_event_badges.dart';
import 'events_meta_chip.dart';
import 'package:lucide_icons/lucide_icons.dart';

class EventsCompletedOnlineCard extends StatefulWidget {
  const EventsCompletedOnlineCard({
    super.key,
    required this.event,
    required this.l10n,
  });

  final EventItem event;
  final AppLocalizations l10n;

  @override
  State<EventsCompletedOnlineCard> createState() =>
      _EventsCompletedOnlineCardState();
}

class _EventsCompletedOnlineCardState extends State<EventsCompletedOnlineCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final borderColor = _hovered
        ? AppColors.accent.withValues(alpha: 0.45)
        : AppColors.borderDark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: FieldWorkChinesePalette.inkWash.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
          boxShadow: _hovered ? AppShadows.eventCardHover : null,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 5,
                  child: Image.asset(
                    event.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => ColoredBox(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      child: Icon(
                        LucideIcons.image,
                        color: AppColors.accent.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: EventsEventBadges(
                    l10n: widget.l10n,
                    status: event.status,
                    format: event.format,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onPrimary,
                          height: 1.25,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.accentLight.withValues(alpha: 0.9),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.hook,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariantDark,
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  EventsMetaChip(
                    icon: LucideIcons.calendar,
                    label: event.date,
                    compact: true,
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
