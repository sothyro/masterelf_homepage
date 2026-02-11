import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../config/app_content.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/launcher_utils.dart';
import 'glass_container.dart';

/// Shows the Media & Posts dialog (Facebook, Telegram, media coverage).
void showMediaPostsPopup(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => const MediaPostsPopup(),
  );
}

class MediaPostsPopup extends StatelessWidget {
  const MediaPostsPopup({super.key});

  static const String _facebookPageUrl = 'https://www.facebook.com/masterelf.vip';

  /// Sample media coverage links – replace with real URLs when available.
  static const List<String> _sampleMediaUrls = [
    'https://www.masterelf.vip',
    'https://www.masterelf.vip',
    'https://www.masterelf.vip',
  ];

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
        padding: EdgeInsets.zero,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 560,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.mediaAndPosts,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, size: 22, color: AppColors.onPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: l10n.close,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.borderDark),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionBlock(
                        icon: LucideIcons.facebook,
                        iconColor: const Color(0xFF1877F2),
                        title: l10n.mediaPostsFacebookTitle,
                        body: l10n.mediaPostsFacebookBody,
                        linkLabel: l10n.mediaPostsFacebookLink,
                        linkUrl: _facebookPageUrl,
                      ),
                      const SizedBox(height: 24),
                      _SectionBlock(
                        icon: LucideIcons.send,
                        title: l10n.mediaPostsTelegramTitle,
                        body: l10n.mediaPostsTelegramBody,
                        linkLabel: l10n.mediaPostsTelegramLink,
                        linkUrl: AppContent.telegramGroupUrl,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.mediaPostsCoverageTitle,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.mediaPostsCoverageBody,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurfaceVariantDark,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 12),
                      ...[
                        (l10n.sampleArticle1, _sampleMediaUrls[0]),
                        (l10n.sampleArticle2, _sampleMediaUrls[1]),
                        (l10n.sampleFeature, _sampleMediaUrls[2]),
                      ].map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            onTap: () => launchUrlExternal(e.$2),
                            borderRadius: BorderRadius.circular(4),
                            child: Row(
                              children: [
                                Icon(LucideIcons.externalLink, size: 16, color: AppColors.accent),
                                const SizedBox(width: 8),
                                Text(
                                  e.$1,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.accent,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.accent,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.onAccent,
                    ),
                    child: Text(l10n.close),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.icon,
    required this.title,
    required this.body,
    required this.linkLabel,
    required this.linkUrl,
    this.iconColor,
  });

  final IconData icon;
  final Color? iconColor;
  final String title;
  final String body;
  final String linkLabel;
  final String linkUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 24, color: iconColor ?? AppColors.accent),
            const SizedBox(width: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => launchUrlExternal(linkUrl),
          borderRadius: BorderRadius.circular(4),
          child: Text(
            linkUrl,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.accent,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.accent,
                ),
          ),
        ),
      ],
    );
  }
}
