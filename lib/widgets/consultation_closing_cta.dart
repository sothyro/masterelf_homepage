import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Bottom conversion band: consultation primary + optional contact secondary.
class ConsultationClosingCta extends StatelessWidget {
  const ConsultationClosingCta({
    super.key,
    required this.heading,
    required this.body,
    required this.isMobile,
    this.primaryLabel,
    this.showContactButton = true,
    this.backgroundColor,
  });

  final String heading;
  final String body;
  final bool isMobile;
  final String? primaryLabel;
  final bool showContactButton;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ctaLabel = primaryLabel ?? l10n.methodClosingCta;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            heading,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.55,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 20 : 24),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: AppShadows.accentButton,
            ),
            child: FilledButton.icon(
              onPressed: () => context.push('/consultations'),
              icon: const Icon(LucideIcons.calendarCheck, size: 20),
              label: Text(ctaLabel),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                elevation: 0,
              ),
            ),
          ),
          if (showContactButton) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.push('/contact'),
              icon: const Icon(LucideIcons.messageCircle, size: 20),
              label: Text(l10n.contactUs),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accent,
                side: const BorderSide(color: AppColors.accent),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
