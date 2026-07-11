import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:video_player/video_player.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/launcher_utils.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  VideoPlayerController? _controller;
  bool _videoReady = false;
  bool _videoError = false;
  void Function()? _loopListener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initVideo();
    });
  }

  Future<void> _initVideo() async {
    if (!mounted) return;
    try {
      // Use .asset() on all platforms; video_player_web resolves assets correctly.
      final VideoPlayerController c = VideoPlayerController.asset(
        AppContent.assetHeroVideo,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      await c.initialize();
      if (!mounted) {
        c.dispose();
        return;
      }
      c.setLooping(true);
      c.setVolume(0);
      // Fallback loop: when position reaches end, seek to start and play (reliable on web where setLooping can fail).
      void listener() {
        final duration = c.value.duration;
        if (!c.value.isPlaying || duration.inMilliseconds <= 0) return;
        final pos = c.value.position.inMilliseconds;
        final end = duration.inMilliseconds - 200;
        if (pos >= end) {
          c.seekTo(Duration.zero);
          c.play();
        }
      }
      _loopListener = listener;
      c.addListener(_loopListener!);
      await c.play();
      if (!mounted) {
        c.removeListener(_loopListener!);
        c.dispose();
        return;
      }
      setState(() {
        _controller = c;
        _videoReady = true;
      });
    } catch (_) {
      if (mounted) setState(() => _videoError = true);
    }
  }

  @override
  void dispose() {
    final c = _controller;
    if (c != null && _loopListener != null) {
      c.removeListener(_loopListener!);
    }
    _controller?.dispose();
    super.dispose();
  }

  double _headlineSize(double width) =>
      Breakpoints.isSmall(width) ? 20 : (Breakpoints.isMedium(width) ? 26 : 32);

  double _highlightSize(double width) =>
      Breakpoints.isSmall(width) ? 38 : (Breakpoints.isMedium(width) ? 46 : 56);

  double _sublineSize(double width) =>
      Breakpoints.isSmall(width) ? 13 : (Breakpoints.isMedium(width) ? 15 : 17);

  EdgeInsets _buttonPadding(double width) => EdgeInsets.symmetric(
        horizontal: Breakpoints.isSmall(width) ? 24 : 32,
        vertical: Breakpoints.isSmall(width) ? 14 : 18,
      );

  double _buttonFontSize(double width) => Breakpoints.isSmall(width) ? 15 : 17;

  List<Widget> _heroHeadlinesAndSubline(
    BuildContext context,
    AppLocalizations l10n,
    TextAlign textAlign,
    double width,
  ) {
    return [
      Semantics(
        header: true,
        child: RichText(
          textAlign: textAlign,
          text: TextSpan(
            style: (Theme.of(context).textTheme.headlineLarge ?? const TextStyle()).copyWith(
              color: AppColors.onPrimary,
              fontWeight: FontWeight.w600,
              fontSize: _headlineSize(width),
              height: 0.88,
            ),
            children: [
              TextSpan(text: l10n.heroHeadline1Prefix),
              TextSpan(
                text: l10n.heroHeadline1Highlight,
                style: highlightStyleForLocale(
                  context,
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: _highlightSize(width),
                ),
              ),
              TextSpan(text: l10n.heroHeadline1Suffix),
            ],
          ),
        ),
      ),
      const SizedBox(height: 10),
      RichText(
        textAlign: textAlign,
        text: TextSpan(
          style: (Theme.of(context).textTheme.headlineLarge ?? const TextStyle()).copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w600,
            fontSize: _headlineSize(width),
            height: 0.88,
          ),
          children: [
            TextSpan(text: l10n.heroHeadline2Prefix),
            TextSpan(
              text: l10n.heroHeadline2Highlight,
              style: highlightStyleForLocale(
                context,
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: _highlightSize(width),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 28),
      Text(
        l10n.heroSubline,
        textAlign: textAlign,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.onPrimary.withValues(alpha: 0.9),
          height: 0.9,
          fontSize: _sublineSize(width),
        ),
      ),
    ];
  }

  List<Widget> _heroCtaButtons(
    BuildContext context,
    AppLocalizations l10n,
    double width,
    WrapAlignment alignment,
  ) {
    return [
      Wrap(
        alignment: alignment,
        spacing: 20,
        runSpacing: 14,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: AppShadows.accentButton,
            ),
            child: FilledButton(
              onPressed: () => context.push('/consultations'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.onAccent,
                padding: _buttonPadding(width),
                elevation: 0,
              ),
              child: Text(
                l10n.bookConsultation,
                style: TextStyle(
                  fontSize: _buttonFontSize(width),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => launchUrlExternal(AppContent.facebookUrl),
            icon: Icon(
              LucideIcons.facebook,
              size: Breakpoints.isSmall(width) ? 18 : 20,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onPrimary,
              side: const BorderSide(color: AppColors.onPrimary),
              padding: _buttonPadding(width),
            ),
            label: Text(
              l10n.heroMasterElfCaption,
              style: TextStyle(
                fontSize: _buttonFontSize(width),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);
    final minHeight = Breakpoints.isSmall(width)
        ? 480.0
        : (Breakpoints.isDesktop(width) ? 1000.0 : 500.0);
    final height = width > 0 ? (width * 9 / 16).clamp(minHeight, 1600.0) : 1000.0;
    final horizontalPadding = isMobile ? 16.0 : 32.0;
    final verticalPadding = isMobile ? 32.0 : 48.0;
    final topInset = isMobile ? (MediaQuery.paddingOf(context).top + 12 + 64) : 0.0;
    final contentAlignment = isMobile ? const Alignment(0, 1.0) : const Alignment(-0.38, 0.42);
    final crossAlign = isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = isMobile ? TextAlign.center : TextAlign.left;
    final wrapAlign = isMobile ? WrapAlignment.center : WrapAlignment.start;

    return RepaintBoundary(
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1) Gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundDark,
                    AppColors.surfaceDark,
                    AppColors.primary.withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
            // 2) Static hero image while video loads (or on error)
            if (!_videoReady || _videoError)
              Positioned.fill(
                child: Image.asset(
                  AppContent.assetHeroBackground,
                  fit: BoxFit.cover,
                ),
              ),
            // 3) Video when ready — use cover to fill the section on wide screens (same as hero image)
            if (_videoReady && _controller != null && _controller!.value.isInitialized)
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              ),
            // 4) Overlay for text contrast
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.45),
                    AppColors.primary.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            // 5) Content
            LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: topInset + verticalPadding,
                    bottom: isMobile ? 16.0 : verticalPadding,
                  ),
                  child: Align(
                    alignment: contentAlignment,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: isMobile ? Alignment.bottomCenter : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 900,
                          maxHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: crossAlign,
                          children: [
                            ..._heroHeadlinesAndSubline(context, l10n, textAlign, width),
                            SizedBox(height: isMobile ? 24 : 36),
                            ..._heroCtaButtons(context, l10n, width, wrapAlign),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
