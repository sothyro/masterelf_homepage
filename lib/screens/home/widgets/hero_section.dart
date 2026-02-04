import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 720),
      padding: const EdgeInsets.only(top: 200, bottom: 200, left: 24, right: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.85),
          ],
        ),
        image: DecorationImage(
          image: AssetImage(AppContent.assetHeroBackground),
          fit: BoxFit.cover,
          opacity: 0.4,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Semantics(
              header: true,
              child: Text(
                l10n.heroHeadline1,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                children: [
                  const TextSpan(text: 'It changes with '),
                  TextSpan(
                    text: 'Strategy.',
                    style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.heroSubline,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onPrimary.withValues(alpha: 0.9),
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: () => context.push('/appointments'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  ),
                  child: Text(l10n.bookConsultation),
                ),
                OutlinedButton(
                  onPressed: () => context.push('/about'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.onPrimary,
                    side: const BorderSide(color: AppColors.onPrimary),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  ),
                  child: Text(l10n.aboutMasterElf),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}
