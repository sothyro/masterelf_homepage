import 'package:flutter/material.dart';

import '../config/app_content.dart';
import '../l10n/app_localizations.dart';
import '../utils/launcher_utils.dart';
import 'social_orbital_medallion.dart';

/// Shows the Media & Posts overlay — transparent, orbital Facebook + Telegram only.
void showMediaPostsPopup(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => const MediaPostsPopup(),
  );
}

class MediaPostsPopup extends StatelessWidget {
  const MediaPostsPopup({super.key});

  void _dismiss(BuildContext context) => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TickerMode(
      enabled: true,
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () => _dismiss(context),
            behavior: HitTestBehavior.opaque,
            child: const SizedBox.expand(),
          ),
          Center(
            child: RepaintBoundary(
              child: SocialOrbitalPair(
                facebookLabel: l10n.tooltipFacebook,
                telegramLabel: l10n.tooltipTelegram,
                onFacebook: () {
                  _dismiss(context);
                  launchUrlExternal(AppContent.facebookUrl);
                },
                onTelegram: () {
                  _dismiss(context);
                  launchTelegram();
                },
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
