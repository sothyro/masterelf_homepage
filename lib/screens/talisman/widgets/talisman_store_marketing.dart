import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../store/widgets/description_with_highlight.dart';

/// Centered intro band below the category strip on /talisman.
class TalismanStoreMarketingIntro extends StatelessWidget {
  const TalismanStoreMarketingIntro({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.talismanStoreIntroHeading,
          textAlign: TextAlign.center,
          style: highlightStyleForLocale(
            context,
            fontSize: isNarrow ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 12),
        DescriptionWithHighlight(
          description: l10n.talismanStoreIntroBody,
          highlightPhrase: l10n.talismanStoreIntroHighlight,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Collection heading plus persuasive intro above the talisman grid.
class TalismanStoreCollectionIntro extends StatelessWidget {
  const TalismanStoreCollectionIntro({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.talismanStoreCollectionHeading,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 10),
        DescriptionWithHighlight(
          description: l10n.talismanStoreCollectionIntro,
          highlightPhrase: l10n.talismanStoreCollectionIntroHighlight,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}

/// Compact reassurance band before the closing CTA.
class TalismanStoreTrustBand extends StatelessWidget {
  const TalismanStoreTrustBand({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isNarrow ? 20 : 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceElevatedDark,
            AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.35)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.talismanStoreTrustHeading,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.accentLight,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.talismanStoreTrustBody,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}

/// Bottom conversion band linking to consultations.
class TalismanStoreClosingCta extends StatelessWidget {
  const TalismanStoreClosingCta({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isNarrow ? 24 : 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceElevatedDark,
            AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.35)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: isNarrow
            ? CrossAxisAlignment.stretch
            : CrossAxisAlignment.start,
        children: [
          Text(
            l10n.talismanStoreClosingHeading,
            style: highlightStyleForLocale(
              context,
              fontSize: isNarrow ? 22 : 26,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.talismanStoreClosingBody,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onSurfaceVariantDark,
                  height: 1.55,
                ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: isNarrow ? Alignment.center : Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: () => context.push('/consultations'),
              icon: const Icon(LucideIcons.calendarCheck, size: 20),
              label: Text(l10n.talismanStoreClosingCta),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
