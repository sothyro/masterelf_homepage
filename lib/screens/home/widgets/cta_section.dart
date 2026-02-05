import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';

class CtaSection extends StatelessWidget {
  const CtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
      color: AppColors.primary,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Column(
          children: [
            Text(
              l10n.finalCtaHeading,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.finalCtaBody,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.9),
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () => context.push('/contact'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(l10n.contactUs),
            ),
          ],
        ),
      ),
    );
  }
}
