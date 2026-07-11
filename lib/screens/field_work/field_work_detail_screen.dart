import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../config/field_work_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import 'field_work_widgets.dart';
import 'widgets/activity_video_player.dart';

class FieldWorkDetailScreen extends StatelessWidget {
  const FieldWorkDetailScreen({super.key, required this.post});

  final FieldWorkPost post;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final paddingH = isMobile ? 16.0 : 24.0;
    final paragraphs = post.localizedBody(locale).split('\n\n');
    final gallery = post.galleryImages.isNotEmpty ? post.galleryImages : [post.coverImage];
    final servicePath = post.consultationPath();

    return Container(
      width: double.infinity,
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: isMobile ? 4 / 5 : 21 / 9,
                child: post.hasVideo
                    ? ActivityVideoPlayer(
                        videoAsset: post.videoAsset!,
                        posterImage: post.coverImage,
                        autoPlay: false,
                        borderRadius: 0,
                      )
                    : Image.asset(
                        post.coverImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => ColoredBox(
                          color: AppColors.primary,
                          child: Icon(
                            fieldWorkRealmIcon(post.realm),
                            color: AppColors.accent,
                            size: 64,
                          ),
                        ),
                      ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.backgroundDark.withValues(alpha: 0.2),
                        AppColors.backgroundDark.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: isMobile ? 100 : 120,
                left: paddingH,
                right: paddingH,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FieldWorkRealmBadge(realm: post.realm, l10n: l10n),
                    const SizedBox(height: 12),
                    Text(
                      post.localizedTitle(locale),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.mapPin,
                          size: 14,
                          color: AppColors.onSurfaceVariantDark,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post.localizedLocation(locale)} · ${formatFieldWorkDate(post.date, locale)}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariantDark,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(paddingH, isMobile ? 28 : 40, paddingH, isMobile ? 48 : 64),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      post.localizedOutcome(locale),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                    ),
                    const SizedBox(height: 24),
                    for (final paragraph in paragraphs)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          paragraph,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.onPrimary.withValues(alpha: 0.92),
                                height: 1.6,
                              ),
                        ),
                      ),
                    if (gallery.length > 1) ...[
                      const SizedBox(height: 12),
                      Text(
                        l10n.fieldWorkGalleryHeading,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 16),
                      _PhotoGrid(images: gallery, isMobile: isMobile),
                    ],
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () => context.go('/field-work'),
                          icon: const Icon(LucideIcons.arrowLeft, size: 18),
                          label: Text(l10n.fieldWorkBackToJournal),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.onPrimary,
                            side: const BorderSide(color: AppColors.borderLight),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => shareFieldWorkOnFacebook(context, post),
                          icon: const Icon(LucideIcons.facebook, size: 18),
                          label: Text(l10n.fieldWorkShareFacebook),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.onPrimary,
                            side: const BorderSide(color: AppColors.borderLight),
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
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({required this.images, required this.isMobile});

  final List<String> images;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = isMobile ? 2 : 3;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 4 / 5,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            images[index],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => ColoredBox(
              color: AppColors.borderDark,
              child: Icon(LucideIcons.image, color: AppColors.accent),
            ),
          ),
        );
      },
    );
  }
}
