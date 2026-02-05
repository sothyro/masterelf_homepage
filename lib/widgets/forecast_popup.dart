import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'glass_container.dart';

class ForecastPopup extends StatelessWidget {
  const ForecastPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: GlassContainer(
        blurSigma: 10,
        color: AppColors.overlayDark.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: AppShadows.dialog,
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.popupTitle1,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.8),
                    ),
              ),
              Text(
                l10n.popupTitle2,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.popupDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: AppColors.onPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevatedDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '12 Animals',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.readFullArticles),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.popupFormPrompt,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.borderDark),
                  ),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.submit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
