import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../theme/app_theme.dart';
import '../utils/mobile_web_performance.dart';
import '../utils/scroll_activity_gate.dart';

/// Default seamless loop length for internal + external orbital motion.
const Duration kMajesticOrbitalCycleDuration = Duration(milliseconds: 20000);

/// Mobile orbital stage: card chrome is smaller; rings use the full frame width.
const double kMobileOrbitalCardBodyScale = 0.76;
const double kMobileOrbitalRingMargin = 6.0;
const double kMobileOrbitalMaxOrbitRxFactor = 0.68;

/// Largest ring rx that fits inside [frameWidth] without clipping off-screen.
double mobileOrbitalExtentScale(
  double frameWidth, {
  double minScale = 0.72,
  double maxScale = 1.05,
}) {
  if (frameWidth <= 0) return 1.0;
  final maxRx = frameWidth / 2 - kMobileOrbitalRingMargin;
  return (maxRx / (frameWidth * kMobileOrbitalMaxOrbitRxFactor))
      .clamp(minScale, maxScale);
}

/// Ceremonial orbit — gentle acceleration wobble layered on steady rotation.
double majesticOrbitalGracefulRotation(
  double t, {
  required double speed,
  required double phase,
}) {
  final turn = t * math.pi * 2 * speed;
  // Keep wobble perfectly periodic so repeat() has no visible reset jump.
  final wobble =
      math.sin(t * math.pi * 2 + phase) * 0.06 +
      math.sin(t * math.pi * 4 + phase * 1.6) * 0.024;
  return turn + phase + wobble;
}

double majesticOrbitalRingBreath(
  double t, {
  required double phase,
  double amount = 0.018,
}) {
  return 1 + math.sin(t * math.pi * 2 + phase) * amount;
}

/// Hover wobble oscillations per [kMajesticOrbitalCycleDuration] — slow and ceremonial.
const double kMajesticHoverWobbleSpeed = 1.25;

/// Layered sine wobble for hover tilt — same periodic language as orbital rings.
double majesticOrbitalHoverTiltWobble(
  double t, {
  required double phase,
  double speed = kMajesticHoverWobbleSpeed,
}) {
  final angle = t * math.pi * 2 * speed + phase;
  return math.sin(angle) * 0.028 +
      math.sin(angle * 2 + phase * 1.6) * 0.011;
}

/// Gentle vertical float on hover, synced to the orbital cycle.
double majesticOrbitalHoverFloat(
  double t, {
  required double phase,
  double speed = kMajesticHoverWobbleSpeed,
}) {
  final angle = t * math.pi * 2 * speed + phase;
  return math.sin(angle) * 4.0 + math.sin(angle * 2 + phase * 1.6) * 1.5;
}

enum _OrbitalRingLayer { behind, front }

/// Reusable 3D orbital card frame with center emblem, satellite rings, shimmer,
/// and hover tilt. Use on any card by passing [child] or [imageAsset].
///
/// ```dart
/// MajesticOrbitalCardFrame(
///   aspectRatio: 4 / 3,
///   imageAsset: 'assets/images/events/comingsoon2027.jpg',
///   topLeft: MyBadge(),
/// )
/// ```
class MajesticOrbitalCardFrame extends StatefulWidget {
  const MajesticOrbitalCardFrame({
    super.key,
    this.child,
    this.imageAsset,
    required this.aspectRatio,
    this.topLeft,
    this.topRight,
    this.showCenterEmblem = true,
    this.showSatelliteOrbits = true,
    this.cycleDuration = kMajesticOrbitalCycleDuration,
    this.borderRadius = 20,
    this.hovered,
    this.enableHoverTiltWobble = true,
    this.orbitExtentScale = 1.0,
    this.cardBodyScale = 1.0,
  }) : assert(
          child != null || imageAsset != null,
          'Provide either child or imageAsset',
        );

  final Widget? child;
  final String? imageAsset;
  final double aspectRatio;
  final Widget? topLeft;
  final Widget? topRight;
  final bool showCenterEmblem;
  final bool showSatelliteOrbits;
  final Duration cycleDuration;
  final double borderRadius;
  /// When set, hover tilt/glow follow this value instead of an internal
  /// [MouseRegion]. Homepage omits this; nested cards can pass parent hover.
  final bool? hovered;
  /// When false, hover keeps glow/tilt but skips oscillating wobble (e.g. parent
  /// card already wobbles the whole spotlight).
  final bool enableHoverTiltWobble;
  /// Scales satellite orbit ellipse radii (>1 extends rings beyond the card).
  final double orbitExtentScale;
  /// Scales only the card chrome; orbital rings keep the outer frame size.
  final double cardBodyScale;

  @override
  State<MajesticOrbitalCardFrame> createState() => MajesticOrbitalCardFrameState();
}

class MajesticOrbitalCardFrameState extends State<MajesticOrbitalCardFrame>
    with SingleTickerProviderStateMixin {
  /// Frames to wait after scroll idle before restarting the orbit ticker.
  static const int _resumeFrameDelay = 2;

  /// Keep cheap paint for this long after resume so blur/shadow shaders do not
  /// compile on the same frames as the ticker restart.
  static const Duration _resumeQualitySettle = Duration(milliseconds: 320);

  bool _hovered = false;
  bool _inViewport = true;
  bool _userScrolling = false;
  bool _resumeSettling = false;
  bool _orbitStartAllowed = false;
  bool _orbitStartScheduled = false;
  int _resumeGeneration = 0;
  Timer? _resumeQualityTimer;
  late final AnimationController _cycleController;
  late final Key _visibilityKey;

  /// Whether the ceremonial cycle controller is actively ticking.
  @visibleForTesting
  bool get isCycleAnimating => _cycleController.isAnimating;

  /// True while post-scroll resume is using the cheap paint path.
  @visibleForTesting
  bool get isResumeSettling => _resumeSettling;

  bool get _shouldAnimate =>
      _inViewport && _orbitStartAllowed && !_userScrolling;

  bool get _forceCheapEffects => _userScrolling || _resumeSettling;

  @override
  void initState() {
    super.initState();
    _visibilityKey = ValueKey<String>(
      'majestic-orbital-${identityHashCode(this)}',
    );
    _cycleController = AnimationController(
      vsync: this,
      duration: widget.cycleDuration,
    );
    _userScrolling = ScrollActivityGate.isUserScrolling;
    ScrollActivityGate.addActivityListener(_onScrollActivity);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scheduleOrbitStartIfNeeded();
  }

  void _scheduleOrbitStartIfNeeded() {
    if (_orbitStartAllowed || _orbitStartScheduled) return;
    if (MobileWebPerformance.prefersReducedMotion(context)) return;

    _orbitStartScheduled = true;
    final defer = MobileWebPerformance.heroMedallionAnimationDefer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (defer <= Duration.zero) {
        setState(() {
          _orbitStartAllowed = true;
          _resumeSettling = true;
        });
        _scheduleSmoothResume(startTicker: true);
        return;
      }
      Future<void>.delayed(defer, () {
        if (!mounted || _orbitStartAllowed) return;
        setState(() {
          _orbitStartAllowed = true;
          _resumeSettling = true;
        });
        _scheduleSmoothResume(startTicker: true);
      });
    });
  }

  void _onScrollActivity() {
    if (!mounted) return;
    final scrolling = ScrollActivityGate.isUserScrolling;
    if (scrolling == _userScrolling && !scrolling) {
      // Still idle; ignore duplicate activity pings.
      return;
    }

    if (scrolling) {
      _cancelSmoothResume();
      if (!_userScrolling || _resumeSettling) {
        setState(() {
          _userScrolling = true;
          _resumeSettling = false;
        });
      } else {
        _userScrolling = true;
      }
      _syncTicker();
      return;
    }

    // Scroll just became idle: keep cheap paint, delay ticker restart.
    setState(() {
      _userScrolling = false;
      _resumeSettling = true;
    });
    _scheduleSmoothResume(startTicker: true);
  }

  void _cancelSmoothResume() {
    _resumeGeneration++;
    _resumeQualityTimer?.cancel();
    _resumeQualityTimer = null;
  }

  /// Restarts motion after [frameDelay] frames, then upgrades paint quality
  /// once the orbit has been ticking for [_resumeQualitySettle].
  void _scheduleSmoothResume({required bool startTicker}) {
    final generation = ++_resumeGeneration;
    _resumeQualityTimer?.cancel();
    _resumeQualityTimer = null;

    void afterFrames(int remaining, VoidCallback action) {
      if (remaining <= 0) {
        action();
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || generation != _resumeGeneration || _userScrolling) {
          return;
        }
        afterFrames(remaining - 1, action);
      });
    }

    afterFrames(_resumeFrameDelay, () {
      if (!mounted || generation != _resumeGeneration || _userScrolling) return;
      if (startTicker) _syncTicker();

      _resumeQualityTimer = Timer(_resumeQualitySettle, () {
        if (!mounted || generation != _resumeGeneration || _userScrolling) {
          return;
        }
        if (!_resumeSettling) return;
        setState(() => _resumeSettling = false);
      });
    });
  }

  void _syncTicker() {
    if (_shouldAnimate) {
      if (!_cycleController.isAnimating) _cycleController.repeat();
    } else if (_cycleController.isAnimating) {
      _cycleController.stop();
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    final visible = info.visibleFraction > 0.08;
    if (visible == _inViewport) return;
    _inViewport = visible;
    if (!visible) {
      _cancelSmoothResume();
      if (_resumeSettling) {
        setState(() => _resumeSettling = false);
      }
      _syncTicker();
      return;
    }
    if (_shouldAnimate && !_cycleController.isAnimating) {
      setState(() => _resumeSettling = true);
      _scheduleSmoothResume(startTicker: true);
    } else {
      _syncTicker();
    }
  }

  @override
  void didUpdateWidget(covariant MajesticOrbitalCardFrame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cycleDuration != widget.cycleDuration) {
      _cycleController.duration = widget.cycleDuration;
    }
  }

  @override
  void dispose() {
    _cancelSmoothResume();
    ScrollActivityGate.removeActivityListener(_onScrollActivity);
    VisibilityDetectorController.instance.forget(_visibilityKey);
    _cycleController.dispose();
    super.dispose();
  }

  bool _preferCheapEffects(BuildContext context) {
    return _forceCheapEffects || MobileWebPerformance.isMobileWeb(context);
  }

  List<BoxShadow> _cardShadows({
    required bool hovered,
    required double lift,
    required bool cheap,
  }) {
    if (cheap) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: hovered ? 0.5 : 0.4),
          blurRadius: hovered ? 16 : 12,
          offset: Offset(0, lift),
        ),
      ];
    }
    return [
      BoxShadow(
        color: AppColors.accentGlow.withValues(alpha: hovered ? 0.42 : 0.22),
        blurRadius: hovered ? 36 : 22,
        spreadRadius: hovered ? 2 : 0,
        offset: Offset(0, lift),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.55),
        blurRadius: hovered ? 28 : 18,
        offset: Offset(0, lift + 8),
      ),
    ];
  }

  Widget _buildOrbitRings({
    required _OrbitalRingLayer layer,
    required bool hovered,
    required bool enableExpensiveEffects,
  }) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _cycleController,
        builder: (context, _) {
          return IgnorePointer(
            child: _CardOrbitalRingsLayer(
              progress: _cycleController.value,
              hovered: hovered,
              layer: layer,
              extentScale: widget.orbitExtentScale,
              enableExpensiveEffects: enableExpensiveEffects,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardChrome({
    required bool hovered,
    required bool cheapEffects,
    required double radius,
  }) {
    final lift = hovered ? 14.0 : 6.0;
    final wobbleActive = hovered && widget.enableHoverTiltWobble;
    final bodyScale = widget.cardBodyScale;

    final surface = _OrbitalFrameSurface(
      borderRadius: radius,
      animation: _cycleController,
      hovered: hovered,
      showCenterEmblem: widget.showCenterEmblem,
      enableExpensiveEffects: !cheapEffects,
      imageAsset: widget.imageAsset,
      topLeft: widget.topLeft,
      topRight: widget.topRight,
      child: widget.child,
    );

    final shadowed = AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: _cardShadows(hovered: hovered, lift: lift, cheap: cheapEffects),
      ),
      child: surface,
    );

    Widget tilted(double tiltX, double tiltY, double hoverLift, Widget child) {
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.0016)
          ..rotateX(tiltX)
          ..rotateY(tiltY)
          ..translateByDouble(0.0, hoverLift, 0.0, 1.0),
        child: child,
      );
    }

    final staticTiltX = hovered ? -0.035 : -0.012;
    final staticTiltY = hovered ? 0.045 : 0.018;
    final staticHoverLift = hovered ? -6.0 : 0.0;

    final transformed = wobbleActive
        ? AnimatedBuilder(
            animation: _cycleController,
            child: shadowed,
            builder: (context, child) {
              final t = _cycleController.value;
              final tiltX =
                  staticTiltX + majesticOrbitalHoverTiltWobble(t, phase: 0.0);
              final tiltY = staticTiltY +
                  majesticOrbitalHoverTiltWobble(t, phase: math.pi * 0.55);
              final hoverLift =
                  staticHoverLift + majesticOrbitalHoverFloat(t, phase: 0.9);
              return tilted(tiltX, tiltY, hoverLift, child!);
            },
          )
        : tilted(staticTiltX, staticTiltY, staticHoverLift, shadowed);

    final ambient = RepaintBoundary(
      child: AnimatedBuilder(
        animation: _cycleController,
        builder: (context, _) {
          return _AmbientGlow(
            hovered: hovered,
            pulse: _cycleController.value,
            borderRadius: radius,
            positioned: false,
          );
        },
      ),
    );

    final scaledChrome = Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(child: ambient),
        Positioned.fill(
          child: _ShadowPlate(
            lift: lift,
            hovered: hovered,
            borderRadius: radius,
            positioned: false,
            cheap: cheapEffects,
          ),
        ),
        Positioned.fill(child: transformed),
      ],
    );

    if (bodyScale == 1.0) return scaledChrome;
    return Transform.scale(
      scale: bodyScale,
      alignment: Alignment.center,
      child: scaledChrome,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveHovered = widget.hovered ?? _hovered;
    final radius = widget.borderRadius;
    final cheapEffects = _preferCheapEffects(context);
    final enableExpensiveEffects = !cheapEffects;

    final frame = AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          if (widget.showSatelliteOrbits)
            Positioned.fill(
              child: _buildOrbitRings(
                layer: _OrbitalRingLayer.behind,
                hovered: effectiveHovered,
                enableExpensiveEffects: enableExpensiveEffects,
              ),
            ),
          Positioned.fill(
            child: RepaintBoundary(
              child: _buildCardChrome(
                hovered: effectiveHovered,
                cheapEffects: cheapEffects,
                radius: radius,
              ),
            ),
          ),
          if (widget.showSatelliteOrbits)
            Positioned.fill(
              child: _buildOrbitRings(
                layer: _OrbitalRingLayer.front,
                hovered: effectiveHovered,
                enableExpensiveEffects: enableExpensiveEffects,
              ),
            ),
        ],
      ),
    );

    final tickered = TickerMode(
      enabled: _shouldAnimate,
      child: frame,
    );

    if (widget.hovered != null) {
      return VisibilityDetector(
        key: _visibilityKey,
        onVisibilityChanged: _onVisibilityChanged,
        child: tickered,
      );
    }

    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: _onVisibilityChanged,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: tickered,
      ),
    );
  }
}

/// Satellite orbit overlay without card chrome — for hero medallions and custom stages.
class MajesticOrbitalRings extends StatelessWidget {
  const MajesticOrbitalRings({
    super.key,
    required this.progress,
    required this.hovered,
    required this.behind,
    this.extentScale = 1.0,
    this.enableExpensiveEffects = true,
  });

  final double progress;
  final bool hovered;
  final bool behind;
  final double extentScale;
  final bool enableExpensiveEffects;

  @override
  Widget build(BuildContext context) {
    return _CardOrbitalRingsLayer(
      progress: progress,
      hovered: hovered,
      layer: behind ? _OrbitalRingLayer.behind : _OrbitalRingLayer.front,
      extentScale: extentScale,
      enableExpensiveEffects: enableExpensiveEffects,
    );
  }
}

class _CardOrbitalRingsLayer extends StatelessWidget {
  const _CardOrbitalRingsLayer({
    required this.progress,
    required this.hovered,
    required this.layer,
    required this.extentScale,
    this.enableExpensiveEffects = true,
  });

  final double progress;
  final bool hovered;
  final _OrbitalRingLayer layer;
  final double extentScale;
  final bool enableExpensiveEffects;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CardOrbitalRingsPainter(
        progress: progress,
        hovered: hovered,
        layer: layer,
        extentScale: extentScale,
        enableExpensiveEffects: enableExpensiveEffects,
      ),
    );
  }
}

class _CardOrbitalRingsPainter extends CustomPainter {
  _CardOrbitalRingsPainter({
    required this.progress,
    required this.hovered,
    required this.layer,
    required this.extentScale,
    required this.enableExpensiveEffects,
  });

  final double progress;
  final bool hovered;
  final _OrbitalRingLayer layer;
  final double extentScale;
  final bool enableExpensiveEffects;

  static const _orbits = [
    (rxF: 0.68, ryF: 0.22, tilt: -0.24, speed: 1.0, satPhases: [0.0, 1.15], stroke: 3.0),
    (rxF: 0.64, ryF: 0.36, tilt: 0.5, speed: -2.0, satPhases: [0.55], stroke: 2.0),
  ];

  Offset _orbitPoint(
    Offset center,
    double rx,
    double ry,
    double tilt,
    double theta,
  ) {
    final lx = rx * math.cos(theta);
    final ly = ry * math.sin(theta);
    return Offset(
      center.dx + lx * math.cos(tilt) - ly * math.sin(tilt),
      center.dy + lx * math.sin(tilt) + ly * math.cos(tilt),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final isFront = layer == _OrbitalRingLayer.front;

    for (var ringIndex = 0; ringIndex < _orbits.length; ringIndex++) {
      final orbit = _orbits[ringIndex];
      final sway = math.sin(progress * math.pi * 2 + orbit.tilt) * 0.045;
      final tilt = orbit.tilt + sway;
      final breath = majesticOrbitalRingBreath(progress, phase: orbit.tilt * math.pi);
      final rx = size.width * orbit.rxF * breath * extentScale;
      final ry = size.height * orbit.ryF * breath * extentScale;

      _drawOrbitArc(
        canvas,
        center: center,
        rx: rx,
        ry: ry,
        tilt: tilt,
        front: isFront,
        stroke: orbit.stroke,
        ringIndex: ringIndex,
      );

      for (final satPhase in orbit.satPhases) {
        _drawSatellite(
          canvas,
          center: center,
          rx: rx,
          ry: ry,
          tilt: tilt,
          front: isFront,
          speed: orbit.speed,
          phase: satPhase * math.pi,
          ringIndex: ringIndex,
        );
      }
    }
  }

  void _drawOrbitArc(
    Canvas canvas, {
    required Offset center,
    required double rx,
    required double ry,
    required double tilt,
    required bool front,
    required double stroke,
    required int ringIndex,
  }) {
    const steps = 100;
    final path = Path();
    final thetaStart = front ? 0.0 : math.pi;
    for (var i = 0; i <= steps; i++) {
      final theta = thetaStart + (i / steps) * math.pi;
      final p = _orbitPoint(center, rx, ry, tilt, theta);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }

    final depthFade = front ? 1.0 : 0.5;
    final baseOpacity = (hovered ? 0.95 : 0.8) * depthFade;
    final strokeWidth = front ? stroke : stroke * 0.7;
    final ringRect = Rect.fromCenter(center: center, width: rx * 2, height: ry * 2);

    if (front && enableExpensiveEffects) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 6
        ..strokeCap = StrokeCap.round
        ..color = AppColors.accentGlow.withValues(alpha: baseOpacity * 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9);
      canvas.drawPath(path, glowPaint);
    } else if (front) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 3
        ..strokeCap = StrokeCap.round
        ..color = AppColors.accentGlow.withValues(alpha: baseOpacity * 0.28);
      canvas.drawPath(path, glowPaint);
    }

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: front
            ? [
                AppColors.accent.withValues(alpha: baseOpacity * 0.4),
                AppColors.accentLight.withValues(alpha: baseOpacity),
                const Color(0xFFFFF4C2).withValues(alpha: baseOpacity),
                AppColors.accentLight.withValues(alpha: baseOpacity),
                AppColors.accent.withValues(alpha: baseOpacity * 0.4),
              ]
            : [
                AppColors.accent.withValues(alpha: baseOpacity * 0.4),
                AppColors.accent.withValues(alpha: baseOpacity * 0.7),
                AppColors.accent.withValues(alpha: baseOpacity * 0.4),
              ],
        stops: front
            ? const [0.0, 0.28, 0.5, 0.72, 1.0]
            : const [0.0, 0.5, 1.0],
      ).createShader(ringRect);
    canvas.drawPath(path, ringPaint);
  }

  void _drawSatellite(
    Canvas canvas, {
    required Offset center,
    required double rx,
    required double ry,
    required double tilt,
    required bool front,
    required double speed,
    required double phase,
    required int ringIndex,
  }) {
    final travel = majesticOrbitalGracefulRotation(progress, speed: speed, phase: phase);
    final onFrontHalf = math.sin(travel) > 0;
    if (onFrontHalf != front) return;

    final satellite = _orbitPoint(center, rx, ry, tilt, travel);
    final scale = front ? 1.0 : 0.65;

    if (enableExpensiveEffects) {
      final direction = speed >= 0 ? 1.0 : -1.0;
      const trailLength = 0.55;
      const trailSteps = 12;
      for (var i = 1; i <= trailSteps; i++) {
        final tTheta = travel - direction * trailLength * (i / trailSteps);
        if ((math.sin(tTheta) > 0) != front) break;
        final tp = _orbitPoint(center, rx, ry, tilt, tTheta);
        final fade = (1 - i / trailSteps);
        canvas.drawCircle(
          tp,
          (2.6 - ringIndex * 0.4) * fade * scale,
          Paint()
            ..color = AppColors.accentLight.withValues(alpha: 0.5 * fade * scale)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
        );
      }

      final glow = Paint()
        ..color = const Color(0xFFFFF4C2).withValues(alpha: 0.75 * scale)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(satellite, (9.0 - ringIndex * 1.5) * scale, glow);
    } else {
      canvas.drawCircle(
        satellite,
        (7.0 - ringIndex * 1.2) * scale,
        Paint()
          ..color = const Color(0xFFFFF4C2).withValues(alpha: 0.35 * scale),
      );
    }

    canvas.drawCircle(
      satellite,
      (4.6 - ringIndex * 0.8) * scale,
      Paint()..color = AppColors.accentLight.withValues(alpha: 0.95 * scale),
    );
    canvas.drawCircle(
      satellite,
      (2.4 - ringIndex * 0.4) * scale,
      Paint()..color = const Color(0xFFFFF8E7),
    );
  }

  @override
  bool shouldRepaint(covariant _CardOrbitalRingsPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.hovered != hovered ||
        oldDelegate.layer != layer ||
        oldDelegate.extentScale != extentScale ||
        oldDelegate.enableExpensiveEffects != enableExpensiveEffects;
  }
}

class _OrbitalFrameSurface extends StatelessWidget {
  const _OrbitalFrameSurface({
    required this.borderRadius,
    required this.animation,
    required this.hovered,
    required this.showCenterEmblem,
    required this.enableExpensiveEffects,
    this.imageAsset,
    this.child,
    this.topLeft,
    this.topRight,
  });

  final double borderRadius;
  final Animation<double> animation;
  final bool hovered;
  final bool showCenterEmblem;
  final bool enableExpensiveEffects;
  final String? imageAsset;
  final Widget? child;
  final Widget? topLeft;
  final Widget? topRight;

  @override
  Widget build(BuildContext context) {
    final innerRadius = borderRadius - 2;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          width: hovered ? 1.8 : 1.2,
          color: AppColors.accent.withValues(alpha: hovered ? 0.85 : 0.55),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accent.withValues(alpha: 0.35),
            AppColors.borderDark,
            const Color(0xFF1A1208),
          ],
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(innerRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(innerRadius - 2),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (imageAsset != null)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final cacheWidth =
                              MobileWebPerformance.cardImageCacheWidth(
                            context,
                            constraints.maxWidth,
                          );
                          final cacheHeight = constraints.maxHeight.isFinite &&
                                  constraints.maxHeight > 0
                              ? MobileWebPerformance.cardImageCacheWidth(
                                  context,
                                  constraints.maxHeight,
                                )
                              : null;
                          return Image.asset(
                            imageAsset!,
                            fit: BoxFit.cover,
                            cacheWidth: cacheWidth,
                            cacheHeight: cacheHeight,
                            filterQuality:
                                MobileWebPerformance.imageFilterQuality(context),
                            errorBuilder: (_, __, ___) => ColoredBox(
                              color: AppColors.accent.withValues(alpha: 0.12),
                              child: Icon(
                                Icons.auto_awesome,
                                size: 48,
                                color: AppColors.accent.withValues(alpha: 0.5),
                              ),
                            ),
                          );
                        },
                      )
                    else
                      child!,
                    if (imageAsset != null) ...[
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0x1AFFFFFF),
                              Colors.transparent,
                              Color(0x47000000),
                            ],
                            stops: [0.0, 0.42, 1.0],
                          ),
                        ),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0x0D000000),
                              Colors.transparent,
                              Color(0x52000000),
                            ],
                            stops: [0.0, 0.55, 1.0],
                          ),
                        ),
                      ),
                    ],
                    RepaintBoundary(
                      child: AnimatedBuilder(
                        animation: animation,
                        builder: (context, _) {
                          return CustomPaint(
                            painter: _ShimmerSweepPainter(
                              progress: animation.value,
                            ),
                          );
                        },
                      ),
                    ),
                    if (showCenterEmblem)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: RepaintBoundary(
                            child: AnimatedBuilder(
                              animation: animation,
                              builder: (context, _) {
                                return LayoutBuilder(
                                  builder: (context, constraints) {
                                    final emblemSize = math.min(
                                          constraints.maxWidth,
                                          constraints.maxHeight,
                                        ) *
                                        (hovered ? 0.72 : 0.68);
                                    return Center(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: emblemSize * 1.04,
                                            height: emblemSize * 1.04,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: RadialGradient(
                                                colors: [
                                                  const Color(0xFF2A1410)
                                                      .withValues(alpha: 0.28),
                                                  const Color(0xFF1A1208)
                                                      .withValues(alpha: 0.14),
                                                  Colors.transparent,
                                                ],
                                                stops: const [0.0, 0.5, 1.0],
                                              ),
                                            ),
                                          ),
                                          _MajesticCenterEmblem(
                                            progress: animation.value,
                                            hovered: hovered,
                                            size: emblemSize,
                                            enableExpensiveEffects:
                                                enableExpensiveEffects,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            CustomPaint(
              painter: _ModernCornerPainter(
                color: AppColors.accent,
                hovered: hovered,
              ),
            ),
            if (topLeft != null)
              Positioned(top: 14, left: 14, child: topLeft!),
            if (topRight != null)
              Positioned(top: 14, right: 14, child: topRight!),
          ],
        ),
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow({
    required this.hovered,
    required this.pulse,
    required this.borderRadius,
    this.positioned = true,
  });

  final bool hovered;
  final double pulse;
  final double borderRadius;
  final bool positioned;

  @override
  Widget build(BuildContext context) {
    final breathe = 0.5 + 0.5 * math.sin(pulse * math.pi * 2);
    final glow = IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius + 8),
          gradient: RadialGradient(
            center: Alignment.center,
            radius: (hovered ? 0.95 : 0.82) + breathe * 0.08,
            colors: [
              const Color(0xFFB83232).withValues(alpha: hovered ? 0.42 : 0.28),
              AppColors.accentGlow.withValues(alpha: 0.22 + breathe * 0.18),
              Colors.transparent,
            ],
            stops: const [0.0, 0.42, 1.0],
          ),
        ),
      ),
    );
    return positioned ? Positioned.fill(child: glow) : glow;
  }
}

class _ShadowPlate extends StatelessWidget {
  const _ShadowPlate({
    required this.lift,
    required this.hovered,
    required this.borderRadius,
    this.positioned = true,
    this.cheap = false,
  });

  final double lift;
  final bool hovered;
  final double borderRadius;
  final bool positioned;
  final bool cheap;

  @override
  Widget build(BuildContext context) {
    final plate = Transform.translate(
      offset: Offset(0, lift + 10),
      child: Transform.scale(
        scale: 0.96,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius + 2),
            color: Colors.black.withValues(alpha: hovered ? 0.55 : 0.4),
            boxShadow: cheap
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.65),
                      blurRadius: 24,
                      offset: const Offset(0, 16),
                    ),
                  ],
          ),
        ),
      ),
    );
    return positioned ? Positioned.fill(child: plate) : plate;
  }
}

class _MajesticCenterEmblem extends StatelessWidget {
  const _MajesticCenterEmblem({
    required this.progress,
    required this.hovered,
    required this.size,
    this.enableExpensiveEffects = true,
  });

  final double progress;
  final bool hovered;
  final double size;
  final bool enableExpensiveEffects;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MajesticCenterEmblemPainter(
          progress: progress,
          hovered: hovered,
          enableExpensiveEffects: enableExpensiveEffects,
        ),
      ),
    );
  }
}

class _MajesticCenterEmblemPainter extends CustomPainter {
  _MajesticCenterEmblemPainter({
    required this.progress,
    required this.hovered,
    required this.enableExpensiveEffects,
  });

  final double progress;
  final bool hovered;
  final bool enableExpensiveEffects;

  void _drawGracefulDashedRing(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required double rotation,
    required double opacity,
    required double strokeWidth,
    required int dashCount,
    required double dashFill,
    double highlightSweep = math.pi / 5,
  }) {
    final rect = Rect.fromCircle(center: center, radius: radius);

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < dashCount; i++) {
      final start = rotation + (i / dashCount) * math.pi * 2;
      final sweep = math.pi * 2 / dashCount * dashFill;
      final localT = (i / dashCount + progress * 0.25) % 1.0;
      final dashOpacity = opacity * (0.55 + 0.45 * math.sin(localT * math.pi * 2));

      basePaint.shader = SweepGradient(
        startAngle: start,
        endAngle: start + sweep,
        colors: [
          AppColors.accent.withValues(alpha: dashOpacity * 0.35),
          AppColors.accentLight.withValues(alpha: dashOpacity),
          AppColors.accent.withValues(alpha: dashOpacity * 0.5),
        ],
        stops: const [0.0, 0.55, 1.0],
        transform: GradientRotation(start),
      ).createShader(rect);

      canvas.drawArc(rect, start, sweep, false, basePaint);
    }

    final highlightStart = rotation + progress * math.pi * 2;
    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 2.4
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: highlightStart,
        endAngle: highlightStart + highlightSweep,
        colors: [
          Colors.transparent,
          AppColors.accentLight.withValues(alpha: opacity),
          const Color(0xFFFFF4C2),
          AppColors.accentLight.withValues(alpha: opacity),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
        transform: GradientRotation(highlightStart),
      ).createShader(rect);
    if (enableExpensiveEffects) {
      highlightPaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);
    }

    canvas.drawArc(rect, highlightStart, highlightSweep, false, highlightPaint);
  }

  void _drawGracefulSolidRing(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required double rotation,
    required double opacity,
    required double strokeWidth,
    double highlightSweep = math.pi / 4,
  }) {
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = SweepGradient(
        startAngle: rotation,
        endAngle: rotation + math.pi * 2,
        colors: [
          AppColors.accent.withValues(alpha: opacity * 0.25),
          AppColors.accent.withValues(alpha: opacity * 0.45),
          AppColors.accent.withValues(alpha: opacity * 0.25),
          AppColors.accent.withValues(alpha: opacity * 0.45),
        ],
        stops: const [0.0, 0.25, 0.5, 0.75],
        transform: GradientRotation(rotation),
      ).createShader(rect);
    canvas.drawCircle(center, radius, trackPaint);

    final highlightStart = rotation + math.sin(progress * math.pi * 2 * 0.5) * 0.08;
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 3.6
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: highlightStart,
        endAngle: highlightStart + highlightSweep,
        colors: [
          Colors.transparent,
          AppColors.accentGlow.withValues(alpha: opacity * 0.75),
          const Color(0xFFFFF4C2),
          AppColors.accentGlow.withValues(alpha: opacity * 0.75),
          Colors.transparent,
        ],
        stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
        transform: GradientRotation(highlightStart),
      ).createShader(rect);
    if (enableExpensiveEffects) {
      glowPaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    }

    canvas.drawArc(rect, highlightStart, highlightSweep, false, glowPaint);

    final crestPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 0.6
      ..strokeCap = StrokeCap.round
      ..color = AppColors.accentLight.withValues(alpha: opacity * 0.85);
    canvas.drawArc(
      rect,
      highlightStart + highlightSweep * 0.28,
      highlightSweep * 0.38,
      false,
      crestPaint,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final center = Offset(cx, cy);
    final pulse = 0.5 + 0.5 * math.sin(progress * math.pi * 2);
    final haloRadius = size.width * (0.46 + pulse * 0.04);

    final halo = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accentGlow.withValues(alpha: hovered ? 0.62 : 0.48),
          const Color(0xFFB83232).withValues(alpha: hovered ? 0.35 : 0.22),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: haloRadius));
    canvas.drawCircle(center, haloRadius, halo);

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(-majesticOrbitalGracefulRotation(progress, speed: 1, phase: 0.4));
    final rayPaint = Paint()
      ..color = AppColors.accentLight.withValues(alpha: hovered ? 0.38 : 0.28)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 12; i++) {
      final angle = i * math.pi / 6;
      final length = size.width * (i.isEven ? 0.34 : 0.24);
      canvas.drawLine(
        Offset.zero,
        Offset(math.cos(angle) * length, math.sin(angle) * length),
        rayPaint,
      );
    }
    canvas.restore();

    final outerRotation = majesticOrbitalGracefulRotation(progress, speed: 1, phase: 0);
    final middleRotation =
        majesticOrbitalGracefulRotation(progress, speed: -2, phase: math.pi * 0.35);
    final innerRotation =
        majesticOrbitalGracefulRotation(progress, speed: 2, phase: math.pi * 0.72);

    final outerRadius = size.width * 0.42 * majesticOrbitalRingBreath(progress, phase: 0);
    final middleRadius =
        size.width * 0.33 * majesticOrbitalRingBreath(progress, phase: math.pi * 0.66);
    final innerRadius =
        size.width * 0.24 * majesticOrbitalRingBreath(progress, phase: math.pi * 1.2);

    _drawGracefulDashedRing(
      canvas,
      center: center,
      radius: outerRadius,
      rotation: outerRotation,
      opacity: hovered ? 0.92 : 0.78,
      strokeWidth: 2.4,
      dashCount: 36,
      dashFill: 0.58,
      highlightSweep: math.pi / 3.5,
    );
    _drawGracefulSolidRing(
      canvas,
      center: center,
      radius: middleRadius,
      rotation: middleRotation,
      opacity: hovered ? 1.0 : 0.88,
      strokeWidth: 2.8,
      highlightSweep: math.pi / 2.6,
    );
    _drawGracefulDashedRing(
      canvas,
      center: center,
      radius: innerRadius,
      rotation: innerRotation,
      opacity: hovered ? 1.0 : 0.92,
      strokeWidth: 1.8,
      dashCount: 20,
      dashFill: 0.52,
      highlightSweep: math.pi / 4.5,
    );

    void drawOrbitJewel({
      required double radius,
      required double rotation,
      required double spread,
      required double dotRadius,
      required Color color,
      bool glow = false,
    }) {
      final jewelCenter =
          Offset(cx + math.cos(rotation) * radius, cy + math.sin(rotation) * radius);
      if (glow && enableExpensiveEffects) {
        final glowPaint = Paint()
          ..color = color.withValues(alpha: 0.55)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(jewelCenter, dotRadius * 2.4, glowPaint);
      } else if (glow) {
        canvas.drawCircle(
          jewelCenter,
          dotRadius * 2.0,
          Paint()..color = color.withValues(alpha: 0.28),
        );
      }
      final dotPaint = Paint()..color = color.withValues(alpha: 0.85 + spread * 0.15);
      canvas.drawCircle(jewelCenter, dotRadius, dotPaint);
    }

    drawOrbitJewel(
      radius: outerRadius,
      rotation: outerRotation,
      spread: pulse,
      dotRadius: 5.5,
      color: AppColors.accentLight,
      glow: true,
    );
    drawOrbitJewel(
      radius: outerRadius,
      rotation: outerRotation + math.pi * 0.66,
      spread: 1 - pulse,
      dotRadius: 4.2,
      color: const Color(0xFFFFF4C2),
    );
    drawOrbitJewel(
      radius: outerRadius,
      rotation: outerRotation + math.pi * 1.33,
      spread: pulse,
      dotRadius: 4.2,
      color: AppColors.accentLight,
      glow: true,
    );
    drawOrbitJewel(
      radius: middleRadius,
      rotation: middleRotation + math.pi * 0.25,
      spread: pulse,
      dotRadius: 5.0,
      color: const Color(0xFFFFF4C2),
      glow: true,
    );
    drawOrbitJewel(
      radius: middleRadius,
      rotation: middleRotation + math.pi * 1.15,
      spread: 1 - pulse,
      dotRadius: 4.0,
      color: AppColors.accentLight,
      glow: true,
    );
    drawOrbitJewel(
      radius: innerRadius,
      rotation: innerRotation + math.pi * 0.5,
      spread: pulse,
      dotRadius: 3.8,
      color: const Color(0xFFFFF8E7),
      glow: true,
    );

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(majesticOrbitalGracefulRotation(progress, speed: 1, phase: math.pi * 0.2));
    final starPath = Path();
    for (var i = 0; i < 8; i++) {
      final outerAngle = i * math.pi / 4 - math.pi / 2;
      final innerAngle = outerAngle + math.pi / 8;
      final outer = Offset(
        math.cos(outerAngle) * size.width * 0.11,
        math.sin(outerAngle) * size.width * 0.11,
      );
      final inner = Offset(
        math.cos(innerAngle) * size.width * 0.05,
        math.sin(innerAngle) * size.width * 0.05,
      );
      if (i == 0) {
        starPath.moveTo(outer.dx, outer.dy);
      } else {
        starPath.lineTo(outer.dx, outer.dy);
      }
      starPath.lineTo(inner.dx, inner.dy);
    }
    starPath.close();

    final starGlow = Paint()
      ..color = AppColors.accentGlow.withValues(alpha: 0.55 + pulse * 0.2);
    if (enableExpensiveEffects) {
      starGlow.maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    }
    canvas.drawPath(starPath, starGlow);

    final starFill = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFF4C2),
          AppColors.accentLight,
          AppColors.accent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: size.width * 0.12));
    canvas.drawPath(starPath, starFill);

    final core = Paint()..color = const Color(0xFFFFF8E7);
    canvas.drawCircle(Offset.zero, size.width * 0.028 + pulse * 1.5, core);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MajesticCenterEmblemPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.hovered != hovered ||
        oldDelegate.enableExpensiveEffects != enableExpensiveEffects;
  }
}

class _ModernCornerPainter extends CustomPainter {
  _ModernCornerPainter({required this.color, required this.hovered});

  final Color color;
  final bool hovered;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = hovered ? 2.0 : 1.4;
    final paint = Paint()
      ..color = color.withValues(alpha: hovered ? 0.9 : 0.65)
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const inset = 10.0;
    const arm = 28.0;

    void corner(Offset origin, {bool flipX = false, bool flipY = false}) {
      final dx = flipX ? -1.0 : 1.0;
      final dy = flipY ? -1.0 : 1.0;
      final path = Path()
        ..moveTo(origin.dx, origin.dy + dy * arm)
        ..lineTo(origin.dx, origin.dy)
        ..lineTo(origin.dx + dx * arm, origin.dy);
      canvas.drawPath(path, paint);

      final dot = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(origin, 2.5, dot);
    }

    corner(Offset(inset, inset));
    corner(Offset(size.width - inset, inset), flipX: true);
    corner(Offset(inset, size.height - inset), flipY: true);
    corner(
      Offset(size.width - inset, size.height - inset),
      flipX: true,
      flipY: true,
    );

    final mid = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(size.width * 0.5 - 18, 6),
      Offset(size.width * 0.5 + 18, 6),
      mid,
    );
    canvas.drawLine(
      Offset(size.width * 0.5 - 18, size.height - 6),
      Offset(size.width * 0.5 + 18, size.height - 6),
      mid,
    );
  }

  @override
  bool shouldRepaint(covariant _ModernCornerPainter oldDelegate) {
    return oldDelegate.hovered != hovered;
  }
}

class _ShimmerSweepPainter extends CustomPainter {
  _ShimmerSweepPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final sweepX = (progress * 1.5 - 0.25) * size.width;
    final rect = Rect.fromLTWH(sweepX - 100, 0, 200, size.height);
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          AppColors.accentLight.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.14),
          AppColors.accentLight.withValues(alpha: 0.08),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _ShimmerSweepPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
