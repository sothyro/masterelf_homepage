import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../config/field_work_content.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../utils/launcher_utils.dart';
import '../../utils/mobile_web_performance.dart';
import '../../widgets/glass_container.dart';
import '../home/widgets/field_work_chinese_design.dart';

const String kFieldWorkFacebookUrl = 'https://www.facebook.com/masterelf.vip';

String fieldWorkRealmLabel(AppLocalizations l10n, FieldWorkRealm realm) {
  return switch (realm) {
    FieldWorkRealm.office => l10n.fieldWorkRealmOffice,
    FieldWorkRealm.ritual => l10n.fieldWorkRealmRitual,
    FieldWorkRealm.site => l10n.fieldWorkRealmSite,
  };
}

IconData fieldWorkRealmIcon(FieldWorkRealm realm) {
  return switch (realm) {
    FieldWorkRealm.office => LucideIcons.building2,
    FieldWorkRealm.ritual => LucideIcons.sparkles,
    FieldWorkRealm.site => LucideIcons.compass,
  };
}

String formatFieldWorkDate(DateTime date, String languageCode) {
  final locale = switch (languageCode) {
    'km' => 'km',
    'zh' => 'zh',
    _ => 'en',
  };
  return DateFormat.yMMMd(locale).format(date);
}

FieldWorkRealm? realmForServiceId(String serviceId) {
  return switch (serviceId) {
    'fengshui' => FieldWorkRealm.site,
    'maosan' => FieldWorkRealm.ritual,
    'bazi' || 'qimeniching' => FieldWorkRealm.office,
    _ => null,
  };
}

FieldWorkRealm realmForPillarId(String pillarId) {
  return switch (pillarId) {
    'feng-shui-site' => FieldWorkRealm.site,
    'mao-shan-blessing' => FieldWorkRealm.ritual,
    _ => FieldWorkRealm.office,
  };
}

/// Prefer [FieldWorkShowcasePillar.realm] on pillar instances.

class FieldWorkRealmBadge extends StatelessWidget {
  const FieldWorkRealmBadge({
    super.key,
    required this.realm,
    required this.l10n,
    this.compact = false,
  });

  final FieldWorkRealm realm;
  final AppLocalizations l10n;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = realmColor(realm);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(fieldWorkRealmIcon(realm), size: compact ? 12 : 14, color: color),
          if (!compact) ...[
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                fieldWorkRealmLabel(l10n, realm),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class FieldWorkFilterBar extends StatelessWidget {
  const FieldWorkFilterBar({
    super.key,
    required this.l10n,
    required this.selectedRealm,
    required this.onRealmChanged,
    this.showVideos = false,
    this.videosOnly = false,
    this.onVideosChanged,
    this.scrollable = true,
  });

  final AppLocalizations l10n;
  final FieldWorkRealm? selectedRealm;
  final ValueChanged<FieldWorkRealm?> onRealmChanged;
  final bool showVideos;
  final bool videosOnly;
  final ValueChanged<bool>? onVideosChanged;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      _FilterChip(
        label: l10n.fieldWorkRealmAll,
        selected: selectedRealm == null && !videosOnly,
        onTap: () {
          onRealmChanged(null);
          onVideosChanged?.call(false);
        },
      ),
      for (final realm in FieldWorkRealm.values)
        _FilterChip(
          label: fieldWorkRealmLabel(l10n, realm),
          selected: selectedRealm == realm && !videosOnly,
          onTap: () {
            onRealmChanged(realm);
            onVideosChanged?.call(false);
          },
        ),
      if (showVideos)
        _FilterChip(
          label: l10n.fieldWorkFilterVideos,
          selected: videosOnly,
          onTap: () {
            onRealmChanged(null);
            onVideosChanged?.call(true);
          },
        ),
    ];

    if (!scrollable) {
      return Wrap(spacing: 8, runSpacing: 8, children: chips);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: chips),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.accent.withValues(alpha: 0.22)
                  : AppColors.surfaceElevatedDark.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? AppColors.accent : AppColors.borderDark,
              ),
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected ? AppColors.accent : AppColors.onSurfaceVariantDark,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class FieldWorkPostCard extends StatelessWidget {
  const FieldWorkPostCard({
    super.key,
    required this.post,
    required this.l10n,
    this.onTap,
    this.compact = false,
  });

  final FieldWorkPost post;
  final AppLocalizations l10n;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final dateLabel = formatFieldWorkDate(post.date, locale);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () => context.push('/field-work/${post.slug}'),
        borderRadius: BorderRadius.circular(14),
        child: GlassContainer(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.surfaceElevatedDark.withValues(alpha: 0.55),
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                child: AspectRatio(
                  aspectRatio: 4 / 5,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        post.coverImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => ColoredBox(
                          color: AppColors.borderDark,
                          child: Icon(
                            fieldWorkRealmIcon(post.realm),
                            color: AppColors.accent,
                            size: 36,
                          ),
                        ),
                      ),
                      if (post.hasVideo)
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.play,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(compact ? 12 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FieldWorkRealmBadge(realm: post.realm, l10n: l10n, compact: compact),
                    SizedBox(height: compact ? 8 : 10),
                    Text(
                      post.localizedTitle(locale),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                          ),
                    ),
                    if (!compact && post.localizedOutcome(locale).isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        post.localizedOutcome(locale),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariantDark,
                              height: 1.35,
                            ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    if (compact)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                LucideIcons.mapPin,
                                size: 12,
                                color: AppColors.onSurfaceVariantDark,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  post.localizedLocation(locale),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: AppColors.onSurfaceVariantDark,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateLabel,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Icon(
                            LucideIcons.mapPin,
                            size: 12,
                            color: AppColors.onSurfaceVariantDark,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              post.localizedLocation(locale),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.onSurfaceVariantDark,
                                  ),
                            ),
                          ),
                          Text(
                            dateLabel,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact activity card for the Activities hub grid (same footprint as [FieldWorkPostCard]).
class FieldWorkPillarCard extends StatelessWidget {
  const FieldWorkPillarCard({
    super.key,
    required this.pillar,
    required this.l10n,
    this.onTap,
  });

  final FieldWorkShowcasePillar pillar;
  final AppLocalizations l10n;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final realm = pillar.realm;
    final languageCode = Localizations.localeOf(context).languageCode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () => context.push(pillar.linkPath),
        borderRadius: BorderRadius.circular(14),
        child: GlassContainer(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.surfaceElevatedDark.withValues(alpha: 0.55),
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                child: AspectRatio(
                  aspectRatio: 4 / 5,
                  child: Image.asset(
                    pillar.coverImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => ColoredBox(
                      color: AppColors.borderDark,
                      child: Icon(
                        pillar.icon,
                        color: pillar.accentColor,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FieldWorkRealmBadge(realm: realm, l10n: l10n),
                    const SizedBox(height: 10),
                    Text(
                      pillar.localizedTitle(languageCode),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      pillar.localizedSubtitle(languageCode),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariantDark,
                            height: 1.35,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FieldWorkFeaturedSpotlight extends StatelessWidget {
  const FieldWorkFeaturedSpotlight({
    super.key,
    required this.post,
    required this.l10n,
  });

  final FieldWorkPost post;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final dateLabel = formatFieldWorkDate(post.date, locale);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/field-work/${post.slug}'),
        borderRadius: BorderRadius.circular(16),
        child: GlassContainer(
          borderRadius: BorderRadius.circular(16),
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        post.coverImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => ColoredBox(
                          color: AppColors.borderDark,
                          child: Icon(
                            fieldWorkRealmIcon(post.realm),
                            color: AppColors.accent,
                            size: 48,
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.backgroundDark.withValues(alpha: 0.75),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                FieldWorkRealmBadge(realm: post.realm, l10n: l10n),
                                if (post.hasVideo)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(LucideIcons.play, size: 12, color: Colors.white),
                                        SizedBox(width: 4),
                                        Text(
                                          'Video',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              post.localizedTitle(locale),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.onPrimary,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.mapPin,
                                  size: 14,
                                  color: AppColors.onSurfaceVariantDark,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${post.localizedLocation(locale)} · $dateLabel',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.onSurfaceVariantDark,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  post.localizedOutcome(locale),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                        height: 1.45,
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

/// Homepage category showcase card (uniform 2×2 grid pillar).
class FieldWorkShowcaseCard extends StatefulWidget {
  const FieldWorkShowcaseCard({
    super.key,
    required this.pillar,
    this.onTap,
    this.stretch = false,
    this.modernChineseStyle = false,
    this.pillarIndex,
  });

  final FieldWorkShowcasePillar pillar;
  final VoidCallback? onTap;
  /// When true (desktop grid row), card fills [IntrinsicHeight] row height.
  final bool stretch;
  /// Homepage modern Chinese aesthetic (corner brackets, seal, mounting bar).
  final bool modernChineseStyle;
  /// Optional 0–3 index for Chinese numeral seal on homepage grid.
  final int? pillarIndex;

  @override
  State<FieldWorkShowcaseCard> createState() => _FieldWorkShowcaseCardState();
}

class _FieldWorkShowcaseCardState extends State<FieldWorkShowcaseCard> {
  bool _isHovered = false;

  static const double _imageAspectRatio = 4 / 5;
  static const double _titleBlockHeight = 44;
  static const double _subtitleBlockHeight = 40;

  Widget _coverImage(String asset, double layoutWidth, FieldWorkShowcasePillar pillar) {
    return Image.asset(
      asset,
      fit: BoxFit.cover,
      cacheWidth: MobileWebPerformance.cardImageCacheWidth(context, layoutWidth),
      filterQuality: MobileWebPerformance.imageFilterQuality(context),
      errorBuilder: (_, __, ___) => ColoredBox(
        color: pillar.accentColor.withValues(alpha: 0.15),
        child: Icon(
          pillar.icon,
          size: 48,
          color: pillar.accentColor,
        ),
      ),
    );
  }

  Widget _buildChinesePortraitCard(
    FieldWorkShowcasePillar pillar,
    String languageCode,
    double layoutWidth,
  ) {
    return AspectRatio(
      aspectRatio: _imageAspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _coverImage(pillar.coverImage, layoutWidth, pillar),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  FieldWorkChinesePalette.ink.withValues(alpha: 0.35),
                  Colors.transparent,
                  Colors.transparent,
                  FieldWorkChinesePalette.ink.withValues(alpha: 0.55),
                  FieldWorkChinesePalette.ink.withValues(alpha: 0.94),
                ],
                stops: const [0.0, 0.28, 0.48, 0.72, 1.0],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 0.85,
                colors: [
                  AppColors.accent.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          if (widget.pillarIndex != null)
            Positioned(
              top: 0,
              left: 0,
              child: ChinesePillarIndexTag(
                index: widget.pillarIndex!,
                accentColor: pillar.accentColor,
              ),
            ),
          Positioned(
            top: 12,
            right: 12,
            child: ChineseRealmSeal(
              icon: pillar.icon,
              accentColor: pillar.accentColor,
              indexLabel: ChineseRealmSeal.labelForIndex(widget.pillarIndex ?? 0),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    FieldWorkChinesePalette.ink.withValues(alpha: 0.72),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 28, 18, 20),
                child: Builder(
                  builder: (context) {
                    final width = MediaQuery.sizeOf(context).width;
                    final titleSize = Breakpoints.isSmall(width)
                        ? 17.0
                        : (Breakpoints.isCompact(width) ? 19.0 : 21.0);
                    final titleStyle = highlightStyleForLocale(
                      context,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                      height: 1.18,
                    ).copyWith(
                      shadows: [
                        Shadow(
                          color: AppColors.accent.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    );

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 36,
                          height: 2,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                pillar.accentColor,
                                AppColors.accent.withValues(alpha: 0.9),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        Text(
                          pillar.localizedTitle(languageCode),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: titleStyle,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          pillar.localizedSubtitle(languageCode),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: FieldWorkChinesePalette.ricePaper.withValues(alpha: 0.92),
                                fontWeight: FontWeight.w700,
                                height: 1.35,
                              ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pillar = widget.pillar;
    final languageCode = Localizations.localeOf(context).languageCode;
    final chinese = widget.modernChineseStyle;

    return LayoutBuilder(
      builder: (context, constraints) {
        final layoutWidth = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final shadow = _isHovered ? AppShadows.cardHover : AppShadows.card;
    final borderColor = chinese
        ? (_isHovered
            ? AppColors.accent.withValues(alpha: 0.75)
            : AppColors.borderDark)
        : (_isHovered
            ? AppColors.borderLight.withValues(alpha: 0.55)
            : AppColors.borderDark);
    final scale = _isHovered ? 1.02 : 1.0;
    final textBlock = chinese
        ? null
        : Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: _titleBlockHeight,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      pillar.localizedTitle(languageCode),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: highlightStyleForLocale(
                        context,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                        height: 1.25,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: _subtitleBlockHeight,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      pillar.localizedSubtitle(languageCode),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariantDark,
                            height: 1.4,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          );

    final radius = chinese ? 18.0 : 14.0;

    final cardBody = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      height: (!chinese && widget.stretch) ? double.infinity : null,
      decoration: BoxDecoration(
        color: chinese ? FieldWorkChinesePalette.ink : AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor,
          width: chinese ? (_isHovered ? 1.5 : 1) : 1,
        ),
        boxShadow: chinese && _isHovered
            ? [
                ...shadow,
                BoxShadow(
                  color: AppColors.accentGlow.withValues(alpha: 0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ]
            : shadow,
      ),
      clipBehavior: Clip.none,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap ?? () => context.push(pillar.linkPath),
          borderRadius: BorderRadius.circular(radius),
          child: chinese
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(radius - 1),
                  child: _buildChinesePortraitCard(pillar, languageCode, layoutWidth),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(radius - 1),
                      ),
                      child: AspectRatio(
                        aspectRatio: _imageAspectRatio,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            _coverImage(pillar.coverImage, layoutWidth, pillar),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.1),
                                    Colors.black.withValues(alpha: 0.55),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: pillar.accentColor.withValues(alpha: 0.6),
                                  ),
                                ),
                                child: Icon(
                                  pillar.icon,
                                  size: 16,
                                  color: pillar.accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.stretch)
                      Expanded(child: textBlock!)
                    else
                      textBlock!,
                  ],
                ),
        ),
      ),
    );

    final scaledCard = chinese
        ? ChineseCornerBrackets(
            color: _isHovered
                ? AppColors.accent
                : AppColors.accent.withValues(alpha: 0.45),
            length: 16,
            inset: 10,
            child: cardBody,
          )
        : cardBody;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          alignment: Alignment.center,
          child: scaledCard,
        ),
      ),
    );
      },
    );
  }
}

class FieldWorkTrustStrip extends StatelessWidget {
  const FieldWorkTrustStrip({super.key, this.realm});

  final FieldWorkRealm? realm;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final path = realm == null ? '/field-work' : '/field-work?realm=${realm!.queryValue()}';

    return GlassContainer(
      borderRadius: BorderRadius.circular(12),
      color: AppColors.surfaceElevatedDark.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(LucideIcons.camera, color: AppColors.accent, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.fieldWorkSeeRealSessions,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onPrimary,
                    height: 1.35,
                  ),
            ),
          ),
          TextButton(
            onPressed: () => context.push(path),
            child: Text(l10n.fieldWorkSeeRealSessionsLink),
          ),
        ],
      ),
    );
  }
}

class FieldWorkJourneyTeaser extends StatelessWidget {
  const FieldWorkJourneyTeaser({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return GlassContainer(
      borderRadius: BorderRadius.circular(14),
      color: AppColors.surfaceElevatedDark.withValues(alpha: 0.55),
      padding: EdgeInsets.all(isNarrow ? 20 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.fieldWorkJourneyTeaser,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.push('/field-work'),
            icon: const Icon(LucideIcons.compass, size: 18),
            label: Text(l10n.fieldWorkJourneyCta),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.onAccent,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> shareFieldWorkUrlOnFacebook(
  BuildContext context,
  String pageUrl,
  String title,
) async {
  final shareUrl =
      'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(pageUrl)}';
  await launchUrlExternal(shareUrl);
}

Future<void> shareFieldWorkOnFacebook(BuildContext context, FieldWorkPost post) async {
  final url = Uri.base.replace(path: '/field-work/${post.slug}').toString();
  await shareFieldWorkUrlOnFacebook(context, url, post.localizedTitle(
    Localizations.localeOf(context).languageCode,
  ));
}
