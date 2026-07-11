import 'package:flutter/material.dart';

import '../../../config/events_data.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';

class EventsEventBadges extends StatelessWidget {
  const EventsEventBadges({
    super.key,
    required this.l10n,
    required this.status,
    required this.format,
  });

  final AppLocalizations l10n;
  final EventStatus status;
  final EventFormat format;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        if (status == EventStatus.completed)
          _Badge(
            label: l10n.eventsCompletedBadge,
            color: AppColors.onSurfaceVariantDark,
            background: Colors.black.withValues(alpha: 0.55),
          ),
        if (status == EventStatus.upcoming)
          _Badge(
            label: l10n.eventsUpcomingBadge,
            color: AppColors.onAccent,
            background: AppColors.accent.withValues(alpha: 0.95),
          ),
        if (format == EventFormat.online)
          _Badge(
            label: l10n.eventsOnlineBadge,
            color: AppColors.accentLight,
            background: Colors.black.withValues(alpha: 0.55),
            outline: true,
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    required this.background,
    this.outline = false,
  });

  final String label;
  final Color color;
  final Color background;
  final bool outline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: outline
            ? Border.all(color: AppColors.accent.withValues(alpha: 0.45))
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
