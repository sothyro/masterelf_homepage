import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/hero_video_platform.dart';
import '../../../utils/launcher_utils.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../utils/mobile_web_performance.dart';
import '../../../utils/scroll_activity_gate.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with WidgetsBindingObserver {
  static const Duration _posterFadeDuration = Duration(milliseconds: 500);

  bool _videoReady = false;
  bool _videoFailed = false;
  bool _posterDismissed = false;
  bool _inViewport = true;
  bool _appActive = true;
  Timer? _posterDismissTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _videoReady = HeroVideoPlatform.isReady;
    _videoFailed = HeroVideoPlatform.failed;
    HeroVideoPlatform.addReadyListener(_onVideoReady);
    ScrollActivityGate.addActivityListener(_syncPlayback);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_startVideo());
    });
  }

  void _onVideoReady() {
    if (!mounted) return;
    setState(() {
      _videoReady = HeroVideoPlatform.isReady;
      _videoFailed = HeroVideoPlatform.failed;
    });
    _schedulePosterDismiss();
    _syncPlayback();
  }

  Future<void> _startVideo() async {
    if (!mounted) return;
    final width = MediaQuery.sizeOf(context).width;
    await HeroVideoPlatform.prewarm(layoutWidth: width);
    if (!mounted) return;
    setState(() {
      _videoReady = HeroVideoPlatform.isReady;
      _videoFailed = HeroVideoPlatform.failed;
    });
    _schedulePosterDismiss();
    _syncPlayback();
  }

  void _schedulePosterDismiss() {
    if (!_videoReady || _videoFailed || _posterDismissed) return;
    _posterDismissTimer?.cancel();
    _posterDismissTimer = Timer(_posterFadeDuration, () {
      if (!mounted || !_videoReady || _videoFailed) return;
      setState(() => _posterDismissed = true);
    });
  }

  void _syncPlayback() {
    if (!_videoReady || _videoFailed) return;
    final shouldPlay =
        _inViewport && _appActive && !ScrollActivityGate.isUserScrolling;
    if (shouldPlay) {
      unawaited(HeroVideoPlatform.resume());
    } else {
      unawaited(HeroVideoPlatform.pause());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final active = state == AppLifecycleState.resumed;
    if (active == _appActive) return;
    _appActive = active;
    _syncPlayback();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    final visible = info.visibleFraction > 0.05;
    if (visible == _inViewport) return;
    _inViewport = visible;
    _syncPlayback();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    HeroVideoPlatform.removeReadyListener(_onVideoReady);
    ScrollActivityGate.removeActivityListener(_syncPlayback);
    _posterDismissTimer?.cancel();
    VisibilityDetectorController.instance.forget(
      const ValueKey<String>('home-hero-section'),
    );
    unawaited(HeroVideoPlatform.pause());
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
    final showPoster = (!_videoReady || _videoFailed) && !_posterDismissed;
    final videoLayer = HeroVideoPlatform.buildVideoLayer();
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
    final heroCacheWidth = MobileWebPerformance.devicePixelCacheWidth(context, width);

    return VisibilityDetector(
      key: const ValueKey<String>('home-hero-section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: RepaintBoundary(
        child: SizedBox(
          width: double.infinity,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
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
              if (showPoster)
                AnimatedOpacity(
                  opacity: (!_videoReady || _videoFailed) ? 1.0 : 0.0,
                  duration: _posterFadeDuration,
                  child: Image.asset(
                    AppContent.assetHeroBackground,
                    fit: BoxFit.cover,
                    cacheWidth: heroCacheWidth,
                    filterQuality: MobileWebPerformance.imageFilterQuality(context),
                  ),
                ),
              if (videoLayer != null)
                AnimatedOpacity(
                  opacity: _videoReady && !_videoFailed ? 1.0 : 0.0,
                  duration: _posterFadeDuration,
                  child: videoLayer,
                ),
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
      ),
    );
  }
}
