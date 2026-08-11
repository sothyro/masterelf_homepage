import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../store/widgets/description_with_highlight.dart';

/// Centered intro band below the category strip on /books.
class BookStoreMarketingIntro extends StatelessWidget {
  const BookStoreMarketingIntro({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.bookStoreIntroHeading,
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
          description: l10n.bookStoreIntroBody,
          highlightPhrase: l10n.bookStoreIntroHighlight,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Section heading plus persuasive intro above a book grid.
class BookStoreSeriesIntro extends StatelessWidget {
  const BookStoreSeriesIntro({
    super.key,
    required this.heading,
    required this.description,
    required this.highlightPhrase,
  });

  final String heading;
  final String description;
  final String highlightPhrase;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          heading,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 10),
        DescriptionWithHighlight(
          description: description,
          highlightPhrase: highlightPhrase,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}

/// Compact reassurance band before the closing CTA.
class BookStoreTrustBand extends StatelessWidget {
  const BookStoreTrustBand({super.key, required this.l10n});

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
            l10n.bookStoreTrustHeading,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.accentLight,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.bookStoreTrustBody,
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
class BookStoreClosingCta extends StatelessWidget {
  const BookStoreClosingCta({super.key, required this.l10n});

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
            l10n.bookStoreClosingHeading,
            style: highlightStyleForLocale(
              context,
              fontSize: isNarrow ? 22 : 26,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.bookStoreClosingBody,
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
              label: Text(l10n.bookStoreClosingCta),
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
