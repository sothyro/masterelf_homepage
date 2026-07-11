import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:video_player/video_player.dart';

import '../../config/app_content.dart';
import '../../config/store_routes.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../utils/breakpoints.dart';
import '../../utils/launcher_utils.dart';
import '../store/widgets/description_with_highlight.dart';
import '../store/widgets/marketplace_category_strip.dart';
import '../store/widgets/section_anchor.dart';
import '../store/widgets/store_content_container.dart';
import '../store/widgets/store_page_hero.dart';

/// Apps page: Master Elf System and Period 9 Mobile App.
class AppsScreen extends StatefulWidget {
  const AppsScreen({super.key});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  final GlobalKey _keyMasterElf = GlobalKey();
  final GlobalKey _keyPeriod9 = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollToSectionIfNeeded();
  }

  void _scrollToSectionIfNeeded() {
    final fragment = GoRouterState.of(context).uri.fragment;
    if (fragment.isEmpty) return;
    if (Breakpoints.isMobile(MediaQuery.sizeOf(context).width)) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final key = switch (fragment) {
        kAppsMasterElfFragment => _keyMasterElf,
        kAppsPeriod9Fragment => _keyPeriod9,
        _ => null,
      };
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.15,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: AppColors.backgroundDark,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StorePageHero(
            title: l10n.appsPageTitle,
            description: l10n.appsPageDescription,
            descriptionHighlight: l10n.appsPageDescriptionHighlight,
            heroHeightNarrow: 480,
            heroHeightWide: 440,
            bottomChild: _SpotlightSection(
              icon: LucideIcons.cpu,
              title: l10n.masterElfSystemSpotlightTitle,
              description: l10n.masterElfSystemSpotlightDesc,
              transparent: true,
              child: _MarketplaceCtaRow(
                primaryButton: FilledButton.icon(
                  onPressed: () => launchUrlExternal(AppContent.baziSystemUrl),
                  icon: const Icon(LucideIcons.externalLink, size: 20),
                  label: Text(l10n.openMasterElfSystem),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.onAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
                secondaryLabel:
                    '${l10n.bookStorePricePrefix}${l10n.masterElfSubscriptionPrice}${l10n.masterElfPricePerMonth}',
                secondaryButton: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.marketplaceAddedToCart),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.surfaceElevatedDark,
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.creditCard, size: 18),
                  label: Text(l10n.masterElfSubscribe),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: const BorderSide(color: AppColors.accent),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ),
            ),
          ),
          StoreContentContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _StoreSectionHeader(
                  heading: l10n.appsFeatureShowcaseHeading,
                  subline: l10n.appsPageSubline,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child: DescriptionWithHighlight(
                      description: l10n.appsFeatureShowcaseMarketingDesc,
                      highlightPhrase: l10n.appsFeatureShowcaseMarketingHighlight,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                MarketplaceCategoryStrip(l10n: l10n),
                const SizedBox(height: 48),
                SectionAnchor(
                  key: _keyMasterElf,
                  child: _FeaturedMasterElfSection(l10n: l10n),
                ),
                const SizedBox(height: 56),
                _AppFeatureShowcase(
                  features: [
                    (AppContent.assetAppQiMen, l10n.appFeatureQiMen),
                    (AppContent.assetAppBaziKhmer, l10n.appFeatureBaziKhmer),
                    (AppContent.assetAppBaziReport, l10n.appFeatureBaziReport),
                    (AppContent.assetAppBaziAge, l10n.appFeatureBaziAge),
                    (AppContent.assetAppBaziStars, l10n.appFeatureBaziStars),
                    (AppContent.assetAppBaziLife, l10n.appFeatureBaziLife),
                    (AppContent.assetAppAdvancedFeatures, l10n.appFeatureAdvancedFeatures),
                    (AppContent.assetAppDateSelection, l10n.appFeatureDateSelection),
                    (AppContent.assetAppMarriage, l10n.appFeatureMarriage),
                  ],
                ),
                const SizedBox(height: 56),
                SectionAnchor(
                  key: _keyPeriod9,
                  child: _FeaturedPeriod9Section(l10n: l10n),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Row of primary CTA, optional price label, and secondary (e.g. Subscribe) for marketplace hero.
class _MarketplaceCtaRow extends StatelessWidget {
  const _MarketplaceCtaRow({
    required this.primaryButton,
    this.secondaryLabel,
    this.secondaryButton,
  });

  final Widget primaryButton;
  final String? secondaryLabel;
  final Widget? secondaryButton;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);
    if (secondaryButton == null) return primaryButton;
    return isNarrow
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              primaryButton,
              if (secondaryLabel != null) ...[
                const SizedBox(height: 12),
                Text(
                  secondaryLabel!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 12),
              secondaryButton!,
            ],
          )
        : Wrap(
            spacing: 16,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              primaryButton,
              if (secondaryLabel != null)
                Text(
                  secondaryLabel!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                      ),
                ),
              secondaryButton!,
            ],
          );
  }
}

/// Store section header with highlight typography.
class _StoreSectionHeader extends StatelessWidget {
  const _StoreSectionHeader({required this.heading, required this.subline});

  final String heading;
  final String subline;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          heading,
          style: highlightStyleForLocale(
            context,
            fontSize: Breakpoints.isMobile(width) ? 28 : 36,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          subline,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariantDark,
                height: 1.5,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Featured Master Elf System block: hero video (looping) + CTA.
class _FeaturedMasterElfSection extends StatefulWidget {
  const _FeaturedMasterElfSection({required this.l10n});

  final AppLocalizations l10n;

  @override
  State<_FeaturedMasterElfSection> createState() => _FeaturedMasterElfSectionState();
}

class _FeaturedMasterElfSectionState extends State<_FeaturedMasterElfSection> {
  bool _hovered = false;
  bool _muted = true;
  VideoPlayerController? _videoController;
  bool _videoReady = false;
  void Function()? _loopListener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initVideo();
    });
  }

  Future<void> _initVideo() async {
    try {
      final VideoPlayerController controller = VideoPlayerController.asset(
        AppContent.assetAppPageVideo,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      await controller.initialize();
      if (!mounted) {
        controller.dispose();
        return;
      }
      controller.setLooping(true);
      controller.setVolume(_muted ? 0 : 1);
      // Fallback loop: when position reaches end, seek to start and play (reliable on mobile/web where setLooping can fail).
      void listener() {
        final duration = controller.value.duration;
        if (duration.inMilliseconds <= 0) return;
        final pos = controller.value.position.inMilliseconds;
        final end = duration.inMilliseconds - 200;
        if (pos >= end) {
          controller.seekTo(Duration.zero);
          controller.play();
        }
      }
      _loopListener = listener;
      controller.addListener(_loopListener!);
      await controller.play();
      if (!mounted) {
        controller.removeListener(_loopListener!);
        controller.dispose();
        return;
      }
      setState(() {
        _videoController = controller;
        _videoReady = true;
      });
      // On mobile, first play() can fail to start; trigger play again after build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _videoController != null && !_videoController!.value.isPlaying) {
          _videoController!.play();
        }
      });
    } catch (e) {
      // Silently handle errors - fallback to image will be shown
      if (mounted) {
        setState(() {
          _videoReady = false;
        });
      }
    }
  }

  void _toggleMute() {
    if (_videoController == null) return;
    setState(() {
      _muted = !_muted;
      _videoController!.setVolume(_muted ? 0 : 1);
    });
  }

  @override
  void dispose() {
    final c = _videoController;
    if (c != null && _loopListener != null) {
      c.removeListener(_loopListener!);
    }
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hovered
                ? AppColors.borderLight.withValues(alpha: 0.6)
                : AppColors.borderDark.withValues(alpha: 0.8),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: -2,
            ),
            if (_hovered)
              BoxShadow(
                color: AppColors.accentGlow.withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, 6),
                spreadRadius: 0,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevatedDark,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: _videoReady &&
                              _videoController != null &&
                              _videoController!.value.isInitialized
                          ? FittedBox(
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: _videoController!.value.size.width,
                                height: _videoController!.value.size.height,
                                child: VideoPlayer(_videoController!),
                              ),
                            )
                          : Image.asset(
                              AppContent.assetAcademy,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (_, __, ___) => Center(
                                child: Icon(
                                  LucideIcons.cpu,
                                  size: 64,
                                  color: AppColors.accent.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(24),
                      child: InkWell(
                        onTap: _toggleMute,
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            _muted ? LucideIcons.volumeX : LucideIcons.volume2,
                            size: 24,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 28,
                    left: 28,
                    right: 28,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.l10n.masterElfSystemSpotlightTitle,
                          style: highlightStyleForLocale(
                            context,
                            fontSize: isNarrow ? 30 : 38,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentLight,
                          ).copyWith(shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.7),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        DescriptionWithHighlight(
                          description: widget.l10n.masterElfSystemSpotlightTagline,
                          highlightPhrase: widget.l10n.masterElfSystemSpotlightTaglineHighlight,
                          baseColor: AppColors.onPrimary,
                        ),
                      ],
                    ),
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

/// Period 9 section with prominent download buttons.
class _FeaturedPeriod9Section extends StatelessWidget {
  const _FeaturedPeriod9Section({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);
    final padding = isNarrow ? 20.0 : 32.0;

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceElevatedDark,
            AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
            AppColors.backgroundDark.withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.3), width: 1),
        boxShadow: [
          ...AppShadows.card,
          BoxShadow(
            color: AppColors.accentGlow.withValues(alpha: 0.08),
            blurRadius: 24,
            spreadRadius: 0,
          ),
        ],
      ),
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.period9SpotlightTitle,
                      style: highlightStyleForLocale(
                        context,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _FreeBadge(l10n: l10n),
                  ],
                ),
                const SizedBox(height: 6),
                DescriptionWithHighlight(
                  description: l10n.period9SpotlightTagline,
                  highlightPhrase: l10n.period9SpotlightTaglineHighlight,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.period9SpotlightDesc,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                        height: 1.5,
                        fontSize: 15,
                      ),
                ),
                const SizedBox(height: 20),
                _Period9Screenshots(),
                const SizedBox(height: 24),
                _DownloadButtonsRow(l10n: l10n),
                const SizedBox(height: 12),
                Text(
                  l10n.period9PremiumLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: _Period9Screenshots(),
                ),
                const SizedBox(width: 40),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            l10n.period9SpotlightTitle,
                            style: highlightStyleForLocale(
                              context,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _FreeBadge(l10n: l10n),
                        ],
                      ),
                      const SizedBox(height: 6),
                      DescriptionWithHighlight(
                        description: l10n.period9SpotlightTagline,
                        highlightPhrase: l10n.period9SpotlightTaglineHighlight,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l10n.period9SpotlightDesc,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.onSurfaceVariantDark,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 28),
                      _DownloadButtonsRow(l10n: l10n),
                      const SizedBox(height: 12),
                      Text(
                        l10n.period9PremiumLabel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariantDark,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

/// Small "Free" badge for marketplace pricing.
class _FreeBadge extends StatelessWidget {
  const _FreeBadge({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
      ),
      child: Text(
        l10n.period9PriceFree,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _DownloadButtonsRow extends StatelessWidget {
  const _DownloadButtonsRow({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isNarrow = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

    return isNarrow
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 56,
                child: _ProminentStoreButton(
                  label: l10n.downloadOnAppStore,
                  icon: Icons.apple,
                  url: AppContent.period9AppStoreUrl,
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 56,
                child: _ProminentStoreButton(
                  label: l10n.getItOnGooglePlay,
                  icon: Icons.play_circle_filled,
                  url: AppContent.period9PlayStoreUrl,
                ),
              ),
            ],
          )
        : IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _ProminentStoreButton(
                      label: l10n.downloadOnAppStore,
                      icon: Icons.apple,
                      url: AppContent.period9AppStoreUrl,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: _ProminentStoreButton(
                      label: l10n.getItOnGooglePlay,
                      icon: Icons.play_circle_filled,
                      url: AppContent.period9PlayStoreUrl,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

class _ProminentStoreButton extends StatelessWidget {
  const _ProminentStoreButton({
    required this.label,
    required this.icon,
    required this.url,
  });

  final String label;
  final IconData icon;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final enabled = url != null && url!.isNotEmpty;

    return FilledButton.icon(
      onPressed: enabled ? () => launchUrlExternal(url!) : null,
      icon: Icon(icon, size: 28, color: enabled ? AppColors.onAccent : AppColors.onSurfaceVariantDark),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: enabled ? AppColors.onAccent : AppColors.onSurfaceVariantDark,
        ),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: enabled ? AppColors.accent : AppColors.surfaceElevatedDark,
        foregroundColor: AppColors.onAccent,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: enabled ? 3 : 0,
        shadowColor: AppColors.accentGlow.withValues(alpha: 0.45),
      ),
    );
  }
}

/// App spotlight style: icon, title, description, and CTA area.
class _SpotlightSection extends StatelessWidget {
  const _SpotlightSection({
    required this.icon,
    required this.title,
    required this.description,
    required this.child,
    this.transparent = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget child;
  final bool transparent;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isNarrow = Breakpoints.isMobile(width);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: transparent
            ? AppColors.surfaceElevatedDark.withValues(alpha: 0.72)
            : AppColors.surfaceElevatedDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: transparent
              ? AppColors.borderLight.withValues(alpha: 0.25)
              : AppColors.borderDark,
          width: transparent ? 1.5 : 1,
        ),
        boxShadow: transparent
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: AppColors.accentGlow.withValues(alpha: 0.06),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: Offset.zero,
                ),
              ]
            : AppShadows.card,
      ),
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(context),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariantDark,
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 24),
                child,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(context),
                const SizedBox(width: 28),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.onSurfaceVariantDark,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: 24),
                      child,
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.4)),
      ),
      child: Icon(icon, size: 48, color: AppColors.accent),
    );
  }
}

void _showPeriod9FullImage(BuildContext context, String asset) {
  showDialog<void>(
    context: context,
    barrierColor: Colors.black87,
    barrierDismissible: true,
    builder: (context) => Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: Image.asset(
                  asset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    LucideIcons.imageOff,
                    size: 48,
                    color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton.filled(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                    foregroundColor: Colors.white,
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

/// Two Period 9 app screenshots. Desktop: stacked with divider. Mobile: side-by-side, compact.
class _Period9Screenshots extends StatelessWidget {
  const _Period9Screenshots();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < Breakpoints.mobile;

        if (isMobile) {
          final imageHeight = (width * 0.52).clamp(160.0, 220.0);
          final gap = 12.0;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _Period9Screenshot(
                  asset: AppContent.assetPeriod9_1,
                  height: imageHeight,
                  onTap: () => _showPeriod9FullImage(context, AppContent.assetPeriod9_1),
                ),
              ),
              SizedBox(width: gap),
              Expanded(
                child: _Period9Screenshot(
                  asset: AppContent.assetPeriod9_2,
                  height: imageHeight,
                  onTap: () => _showPeriod9FullImage(context, AppContent.assetPeriod9_2),
                ),
              ),
            ],
          );
        }

        final imageHeight = (width * 0.5).clamp(280.0, 420.0);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Period9Screenshot(asset: AppContent.assetPeriod9_1, height: imageHeight),
            const SizedBox(height: 20),
            Divider(height: 1, color: AppColors.borderDark, indent: 0, endIndent: 0),
            const SizedBox(height: 20),
            _Period9Screenshot(asset: AppContent.assetPeriod9_2, height: imageHeight),
          ],
        );
      },
    );
  }
}

class _Period9Screenshot extends StatelessWidget {
  const _Period9Screenshot({
    required this.asset,
    required this.height,
    this.onTap,
  });

  final String asset;
  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark, width: 1),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        asset,
        fit: BoxFit.cover,
        width: double.infinity,
        height: height,
        errorBuilder: (_, __, ___) => SizedBox(
          width: double.infinity,
          height: height,
          child: Center(
            child: Icon(LucideIcons.smartphone, size: 40, color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.5)),
          ),
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }
}

/// Product showcase: grid of app feature screens with labels.
class _AppFeatureShowcase extends StatelessWidget {
  const _AppFeatureShowcase({required this.features});

  final List<(String asset, String title)> features;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = Breakpoints.isSmall(width) || Breakpoints.isMobile(width)
        ? 1
        : Breakpoints.isTabletOnly(width)
            ? 2
            : 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3 / 4,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final e = features[index];
        return _AppFeatureCard(asset: e.$1, title: e.$2);
      },
    );
  }
}

class _AppFeatureCard extends StatefulWidget {
  const _AppFeatureCard({required this.asset, required this.title});

  final String asset;
  final String title;

  @override
  State<_AppFeatureCard> createState() => _AppFeatureCardState();
}

class _AppFeatureCardState extends State<_AppFeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? AppColors.borderLight.withValues(alpha: 0.5) : AppColors.borderDark,
            width: _hovered ? 1.5 : 1,
          ),
          boxShadow: _hovered ? AppShadows.cardHover : AppShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                widget.asset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(LucideIcons.image, size: 48, color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.5)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

