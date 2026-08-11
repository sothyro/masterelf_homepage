import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../home/widgets/field_work_chinese_design.dart';

class EventsWhyAttendBand extends StatelessWidget {
  const EventsWhyAttendBand({
    super.key,
    required this.l10n,
    required this.isMobile,
    required this.onRegister,
  });

  final AppLocalizations l10n;
  final bool isMobile;
  final VoidCallback onRegister;

  @override
  Widget build(BuildContext context) {
    return FieldWorkChineseCtaPanel(
      isMobile: isMobile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              EventsGatheringSeal(size: isMobile ? 36 : 44),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  l10n.eventsWhyAttendTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 14 : 18),
          Text(
            l10n.eventsWhyAttendLead,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.6,
                ),
          ),
          SizedBox(height: isMobile ? 20 : 28),
          _WhyAttendBullet(icon: LucideIcons.sparkles, text: l10n.eventsWhyAttend1),
          SizedBox(height: isMobile ? 12 : 16),
          _WhyAttendBullet(icon: LucideIcons.users, text: l10n.eventsWhyAttend2),
          SizedBox(height: isMobile ? 12 : 16),
          _WhyAttendBullet(icon: LucideIcons.calendarCheck, text: l10n.eventsWhyAttend3),
          SizedBox(height: isMobile ? 22 : 28),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: onRegister,
                icon: const Icon(LucideIcons.calendarCheck, size: 18),
                label: Text(l10n.registerForEvent),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.onAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
              TextButton.icon(
                onPressed: () => context.push('/consultations'),
                icon: const Icon(LucideIcons.arrowRight, size: 18),
                label: Text(l10n.eventsConsultationLink),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WhyAttendBullet extends StatelessWidget {
  const _WhyAttendBullet({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.35)),
          ),
          child: Icon(icon, size: 20, color: AppColors.accent),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariantDark,
                    height: 1.5,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
