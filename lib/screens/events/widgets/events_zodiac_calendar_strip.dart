import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';

class EventsZodiacCalendarStrip extends StatelessWidget {
  const EventsZodiacCalendarStrip({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isNarrow ? 16 : 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedDark.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.calendarRange,
                size: 18,
                color: AppColors.accent.withValues(alpha: 0.9),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.eventsZodiacStripLabel,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.accentLight,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (isNarrow)
            Column(
              children: [
                _ZodiacNode(label: l10n.eventsZodiacStripPhoenix, completed: true),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Icon(
                    LucideIcons.arrowDown,
                    size: 18,
                    color: AppColors.accent.withValues(alpha: 0.6),
                  ),
                ),
                _ZodiacNode(label: l10n.eventsZodiacStripGoat, completed: false),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _ZodiacNode(
                    label: l10n.eventsZodiacStripPhoenix,
                    completed: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    LucideIcons.arrowRight,
                    size: 20,
                    color: AppColors.accent.withValues(alpha: 0.6),
                  ),
                ),
                Expanded(
                  child: _ZodiacNode(
                    label: l10n.eventsZodiacStripGoat,
                    completed: false,
                    highlight: true,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ZodiacNode extends StatelessWidget {
  const _ZodiacNode({
    required this.label,
    required this.completed,
    this.highlight = false,
  });

  final String label;
  final bool completed;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.accent.withValues(alpha: 0.12)
            : Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: highlight
              ? AppColors.accent.withValues(alpha: 0.5)
              : AppColors.borderDark,
        ),
      ),
      child: Row(
        children: [
          Icon(
            completed ? LucideIcons.checkCircle2 : LucideIcons.sparkles,
            size: 16,
            color: completed
                ? AppColors.onSurfaceVariantDark
                : AppColors.accent,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: highlight
                        ? AppColors.accentLight
                        : AppColors.onPrimary.withValues(alpha: 0.88),
                    fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
