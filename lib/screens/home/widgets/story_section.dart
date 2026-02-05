import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 24),
      color: AppColors.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sectionStoryHeading,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.sectionStoryPara1,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.sectionStoryPara2,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.sectionStoryPara3,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () => context.push('/about'),
              child: Text(l10n.sectionStoryCtaButton),
            ),
            const SizedBox(height: 48),
            Text(
              l10n.featuredIn,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (i) => Container(
                  width: 100,
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'Logo ${i + 1}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
