import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import 'forecast_popup.dart';

class StickyCtaBar extends StatefulWidget {
  const StickyCtaBar({super.key});

  @override
  State<StickyCtaBar> createState() => _StickyCtaBarState();
}

class _StickyCtaBarState extends State<StickyCtaBar> {
  bool _dismissed = false;

  void _openPopup() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const ForecastPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;

    return Material(
      elevation: 8,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        color: AppColors.accent,
        child: Row(
          children: [
            const Icon(LucideIcons.megaphone, color: AppColors.onAccent, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.stickyCtaText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            TextButton(
              onPressed: _openPopup,
              child: Text(
                l10n.stickyCtaText,
                style: const TextStyle(color: AppColors.onAccent, fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.x, color: AppColors.onAccent, size: 20),
              onPressed: () => setState(() => _dismissed = true),
              tooltip: 'Dismiss',
            ),
          ],
        ),
      ),
    );
  }
}
