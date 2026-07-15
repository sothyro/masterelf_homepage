import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';

/// Desktop press-logo tile size (max).
const double kFeaturedLogoSizeDesktop = 256;

/// How far the desktop story portrait overlaps above the Featured In band.
const double kFeaturedPortraitOverlap = 96;

/// Responsive square logo tile size for the Featured In marquee.
double featuredLogoSize(double viewportWidth) {
  if (viewportWidth >= Breakpoints.tablet) return 256;
  if (viewportWidth >= Breakpoints.mobile) return 200;
  if (viewportWidth >= 400) return 160;
  return 128;
}

/// Shared layout numbers for the Featured In footer band and story portrait inset.
class FeaturedInLayoutMetrics {
  FeaturedInLayoutMetrics(this.viewportWidth)
      : isMobile = Breakpoints.isMobile(viewportWidth),
        logoSize = featuredLogoSize(viewportWidth);

  final double viewportWidth;
  final bool isMobile;
  final double logoSize;

  double get headerFontSize => isMobile ? 28.0 : 52.0;
  double get headerGap => isMobile ? 20.0 : 28.0;
  double get outerPadding => 48.0;

  /// Total vertical space of the Featured In footer band inside [StorySection].
  double get bandHeight =>
      outerPadding + headerFontSize * 1.2 + headerGap + logoSize;

  /// Bottom inset for the desktop story portrait (above the logo strip).
  double get portraitBottomInset => bandHeight - kFeaturedPortraitOverlap;
}

/// Estimated vertical space used by the Featured In footer band in [StorySection].
double estimatedFeaturedInBandHeight({required bool isMobile}) {
  final viewportWidth = isMobile ? Breakpoints.mobile - 1 : Breakpoints.tablet;
  return FeaturedInLayoutMetrics(viewportWidth).bandHeight;
}

/// Featured In strip: heading + infinite marquee of press logos in square frames.
class FeaturedInSection extends StatelessWidget {
  const FeaturedInSection({super.key, required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final metrics = FeaturedInLayoutMetrics(MediaQuery.sizeOf(context).width);
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    final header = Text(
      l10n.featuredIn,
      textAlign: TextAlign.center,
      style: highlightStyleForLocale(
        context,
        fontSize: metrics.headerFontSize,
        fontWeight: FontWeight.bold,
        color: AppColors.accent,
        height: 1.2,
      ).copyWith(
        shadows: [
          Shadow(
            color: AppColors.accent.withValues(alpha: 0.4),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: header),
        SizedBox(height: metrics.headerGap),
        disableAnimations
            ? _FeaturedInStaticRow(logoSize: metrics.logoSize)
            : _FeaturedInMarquee(logoSize: metrics.logoSize),
      ],
    );
  }
}

/// Static logo row when the user prefers reduced motion.
class _FeaturedInStaticRow extends StatelessWidget {
  const _FeaturedInStaticRow({required this.logoSize});

  final double logoSize;

  @override
  Widget build(BuildContext context) {
    final cacheWidth =
        (logoSize * MediaQuery.devicePixelRatioOf(context)).round();
    return SizedBox(
      width: double.infinity,
      height: logoSize,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        child: Row(
          children: [
            for (final assetPath in AppContent.featuredPressLogos)
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: _FeaturedLogoFrame(
                  assetPath: assetPath,
                  size: logoSize,
                  cacheWidth: cacheWidth,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedInMarquee extends StatefulWidget {
  const _FeaturedInMarquee({required this.logoSize});

  final double logoSize;

  @override
  State<_FeaturedInMarquee> createState() => _FeaturedInMarqueeState();
}

class _FeaturedInMarqueeState extends State<_FeaturedInMarquee>
    with SingleTickerProviderStateMixin {
  static const double _speedPxPerSec = 48;
  static const double _gap = 24;
  static const double _fadeWidth = 48;

  late final AnimationController _controller;
  bool _paused = false;
  bool _inViewport = false;
  bool _animationStarted = false;
  bool _disposed = false;
  double _setWidth = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 48),
    );
  }

  @override
  void didUpdateWidget(covariant _FeaturedInMarquee oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.logoSize != widget.logoSize && _inViewport) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimation());
    }
  }

  void _startAnimation() {
    if (!mounted || _disposed || !_inViewport) return;
    _setWidth = _trackSetWidth(widget.logoSize);
    final durationMs = (_setWidth / _speedPxPerSec * 1000).round();
    _controller
      ..duration = Duration(milliseconds: durationMs.clamp(12000, 90000))
      ..repeat();
    _animationStarted = true;
  }

  void _stopAnimation() {
    if (_disposed || !_animationStarted) return;
    _controller.stop();
    _animationStarted = false;
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted || _disposed) return;
    final visible = info.visibleFraction > 0;
    if (visible == _inViewport) return;
    _inViewport = visible;
    if (visible) {
      if (!_animationStarted) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimation());
      } else if (!_paused) {
        _controller.repeat();
      }
    } else {
      _stopAnimation();
    }
  }

  static double _trackSetWidth(double logoSize) {
    final count = AppContent.featuredPressLogos.length;
    return count * (logoSize + _gap);
  }

  @override
  void dispose() {
    _disposed = true;
    VisibilityDetectorController.instance.forget(
      const ValueKey<String>('featured-in-marquee'),
    );
    _controller.dispose();
    super.dispose();
  }

  void _setPaused(bool paused) {
    if (_paused == paused || _disposed) return;
    _paused = paused;
    if (!_inViewport) return;
    if (paused) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
  }

  Widget _buildTrack(double logoSize, int cacheWidth) {
    final logos = AppContent.featuredPressLogos;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var copy = 0; copy < 2; copy++)
          for (final assetPath in logos)
            Padding(
              padding: const EdgeInsets.only(right: _gap),
              child: _FeaturedLogoFrame(
                assetPath: assetPath,
                size: logoSize,
                cacheWidth: cacheWidth,
              ),
            ),
      ],
    );
  }

  Widget _edgeFade({required Alignment alignment}) {
    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: Container(
          width: _fadeWidth,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: alignment == Alignment.centerLeft
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              end: alignment == Alignment.centerLeft
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              colors: [
                AppColors.backgroundDark,
                AppColors.backgroundDark.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logoSize = widget.logoSize;
    final setWidth = _setWidth > 0 ? _setWidth : _trackSetWidth(logoSize);
    final cacheWidth = (logoSize * MediaQuery.devicePixelRatioOf(context)).round();

    return VisibilityDetector(
      key: const ValueKey<String>('featured-in-marquee'),
      onVisibilityChanged: _onVisibilityChanged,
      child: MouseRegion(
        onEnter: (_) => _setPaused(true),
        onExit: (_) => _setPaused(false),
        child: SizedBox(
          width: double.infinity,
          height: logoSize,
          child: ClipRect(
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                OverflowBox(
                  alignment: Alignment.centerLeft,
                  minWidth: 0,
                  maxWidth: double.infinity,
                  maxHeight: logoSize,
                  child: RepaintBoundary(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(-setWidth * _controller.value, 0),
                          child: child,
                        );
                      },
                      child: _buildTrack(logoSize, cacheWidth),
                    ),
                  ),
                ),
                _edgeFade(alignment: Alignment.centerLeft),
                _edgeFade(alignment: Alignment.centerRight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedLogoFrame extends StatelessWidget {
  const _FeaturedLogoFrame({
    required this.assetPath,
    required this.size,
    required this.cacheWidth,
  });

  final String assetPath;
  final double size;
  final int cacheWidth;

  @override
  Widget build(BuildContext context) {
    final borderRadius = size < 160 ? 10.0 : 14.0;

    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              assetPath,
              width: size,
              height: size,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              cacheWidth: cacheWidth,
              gaplessPlayback: true,
              errorBuilder: (context, error, stackTrace) => ColoredBox(
                color: AppColors.surfaceElevatedDark,
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.onSurfaceVariantDark,
                  size: size * 0.22,
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: AppColors.borderLight.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
