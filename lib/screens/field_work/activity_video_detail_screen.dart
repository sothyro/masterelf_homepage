import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../config/field_work_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../widgets/page_content_inset.dart';
import 'field_work_widgets.dart';
import 'widgets/activity_video_player.dart';

class ActivityVideoDetailScreen extends StatelessWidget {
  const ActivityVideoDetailScreen({super.key, required this.video});

  final ActivityVideoSpotlight video;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final servicePath = video.consultationPath();

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: Padding(
        padding: pageContentPadding(
          context,
          bottom: isMobile ? 48 : 64,
        ).add(EdgeInsets.only(top: isMobile ? 0 : 40)),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FieldWorkRealmBadge(realm: video.realm, l10n: l10n),
                const SizedBox(height: 16),
                Text(
                  video.title,
                  style: highlightStyleForLocale(
                    context,
                    fontSize: isMobile ? 26 : 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onPrimary,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  video.subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                        height: 1.45,
                      ),
                ),
                const SizedBox(height: 28),
                Center(
                  child: ActivityVideoPlayer(
                    videoAsset: video.videoAsset,
                    posterImage: video.posterImage,
                    autoPlay: true,
                    maxWidth: isMobile
                        ? width - pageContentHorizontalPadding(width) * 2
                        : 420,
                  ),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => context.go('/field-work'),
                      icon: const Icon(LucideIcons.arrowLeft, size: 18),
                      label: Text(l10n.fieldWorkBackToActivities),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.onPrimary,
                        side: const BorderSide(color: AppColors.borderLight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => shareActivityVideoOnFacebook(context, video),
                      icon: const Icon(LucideIcons.facebook, size: 18),
                      label: Text(l10n.fieldWorkShareFacebook),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.onPrimary,
                        side: const BorderSide(color: AppColors.borderLight),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    if (servicePath != null)
                      FilledButton.icon(
                        onPressed: () => context.push(servicePath),
                        icon: const Icon(LucideIcons.calendarCheck, size: 18),
                        label: Text(l10n.fieldWorkRelatedService),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: AppColors.onAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void shareActivityVideoOnFacebook(BuildContext context, ActivityVideoSpotlight video) {
  final url = Uri.base.replace(path: video.detailPath()).toString();
  shareFieldWorkUrlOnFacebook(context, url, video.title);
}
