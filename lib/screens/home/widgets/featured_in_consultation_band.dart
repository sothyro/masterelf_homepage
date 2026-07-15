import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import 'featured_in_section.dart';

/// Featured In logo marquee plus "Book a consultation" CTA (field-work layout).
class FeaturedInConsultationBand extends StatelessWidget {
  const FeaturedInConsultationBand({
    super.key,
    required this.l10n,
    this.showConsultationButton = true,
  });

  final AppLocalizations l10n;
  final bool showConsultationButton;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final paddingH = isMobile ? 16.0 : 24.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        paddingH,
        isMobile ? 48 : 64,
        paddingH,
        isMobile ? 32 : 40,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FeaturedInSection(l10n: l10n),
              if (showConsultationButton) ...[
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () => context.push('/consultations'),
                  icon: const Icon(LucideIcons.calendarCheck, size: 18),
                  label: Text(l10n.methodClosingCta),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
