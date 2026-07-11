import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../theme/app_theme.dart';

/// Default seamless loop length for internal + external orbital motion.
const Duration kMajesticOrbitalCycleDuration = Duration(milliseconds: 20000);

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

  @override
  State<MajesticOrbitalCardFrame> createState() =>
      _MajesticOrbitalCardFrameState();
}

class _MajesticOrbitalCardFrameState extends State<MajesticOrbitalCardFrame>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _cycleController;

  @override
  void initState() {
    super.initState();
    _cycleController = AnimationController(
      vsync: this,
      duration: widget.cycleDuration,
    )..repeat();
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
    _cycleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveHovered = widget.hovered ?? _hovered;
    final radius = widget.borderRadius;

    final frame = AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: AnimatedBuilder(
        animation: _cycleController,
        builder: (context, _) {
          final t = _cycleController.value;
          final wobbleActive = effectiveHovered && widget.enableHoverTiltWobble;
          final hoverWobbleX = wobbleActive
              ? majesticOrbitalHoverTiltWobble(t, phase: 0.0)
              : 0.0;
          final hoverWobbleY = wobbleActive
              ? majesticOrbitalHoverTiltWobble(t, phase: math.pi * 0.55)
              : 0.0;
          final hoverFloat = wobbleActive
              ? majesticOrbitalHoverFloat(t, phase: 0.9)
              : 0.0;
          final tiltX = (effectiveHovered ? -0.035 : -0.012) + hoverWobbleX;
          final tiltY = (effectiveHovered ? 0.045 : 0.018) + hoverWobbleY;
          final lift = effectiveHovered ? 14.0 : 6.0;
          final hoverLift = effectiveHovered ? -6.0 + hoverFloat : 0.0;

          final cardBody = Positioned.fill(
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0016)
                ..rotateX(tiltX)
                ..rotateY(tiltY)
                ..translateByDouble(0.0, hoverLift, 0.0, 1.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGlow.withValues(
                        alpha: effectiveHovered ? 0.42 : 0.22,
                      ),
                      blurRadius: effectiveHovered ? 36 : 22,
                      spreadRadius: effectiveHovered ? 2 : 0,
                      offset: Offset(0, lift),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.55),
                      blurRadius: effectiveHovered ? 28 : 18,
                      offset: Offset(0, lift + 8),
                    ),
                  ],
                ),
                child: _OrbitalFrameSurface(
                  borderRadius: radius,
                  shimmerProgress: t,
                  animationProgress: t,
                  hovered: effectiveHovered,
                  showCenterEmblem: widget.showCenterEmblem,
                  imageAsset: widget.imageAsset,
                  topLeft: widget.topLeft,
                  topRight: widget.topRight,
                  child: widget.child,
                ),
              ),
            ),
          );

          return Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: [
              _AmbientGlow(hovered: effectiveHovered, pulse: t, borderRadius: radius),
              _ShadowPlate(lift: lift, hovered: effectiveHovered, borderRadius: radius),
              if (widget.showSatelliteOrbits)
                Positioned.fill(
                  child: IgnorePointer(
                    child: _CardOrbitalRingsLayer(
                      progress: t,
                      hovered: effectiveHovered,
                      layer: _OrbitalRingLayer.behind,
                      extentScale: widget.orbitExtentScale,
                    ),
                  ),
                ),
              cardBody,
              if (widget.showSatelliteOrbits)
                Positioned.fill(
                  child: IgnorePointer(
                    child: _CardOrbitalRingsLayer(
                      progress: t,
                      hovered: effectiveHovered,
                      layer: _OrbitalRingLayer.front,
                      extentScale: widget.orbitExtentScale,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );

    if (widget.hovered != null) {
      return frame;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: frame,
    );
  }
}

class _CardOrbitalRingsLayer extends StatelessWidget {
  const _CardOrbitalRingsLayer({
    required this.progress,
    required this.hovered,
    required this.layer,
    required this.extentScale,
  });

  final double progress;
  final bool hovered;
  final _OrbitalRingLayer layer;
  final double extentScale;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CardOrbitalRingsPainter(
        progress: progress,
        hovered: hovered,
        layer: layer,
        extentScale: extentScale,
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
  });

  final double progress;
  final bool hovered;
  final _OrbitalRingLayer layer;
  final double extentScale;

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

    if (front) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 6
        ..strokeCap = StrokeCap.round
        ..color = AppColors.accentGlow.withValues(alpha: baseOpacity * 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9);
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
        oldDelegate.extentScale != extentScale;
  }
}

class _OrbitalFrameSurface extends StatelessWidget {
  const _OrbitalFrameSurface({
    required this.borderRadius,
    required this.shimmerProgress,
    required this.animationProgress,
    required this.hovered,
    required this.showCenterEmblem,
    this.imageAsset,
    this.child,
    this.topLeft,
    this.topRight,
  });

  final double borderRadius;
  final double shimmerProgress;
  final double animationProgress;
  final bool hovered;
  final bool showCenterEmblem;
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
                      Image.asset(
                        imageAsset!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => ColoredBox(
                          color: AppColors.accent.withValues(alpha: 0.12),
                          child: Icon(
                            LucideIcons.sparkles,
                            size: 48,
                            color: AppColors.accent.withValues(alpha: 0.5),
                          ),
                        ),
                      )
                    else
                      child!,
                    if (imageAsset != null) ...[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.1),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.28),
                            ],
                            stops: const [0.0, 0.42, 1.0],
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.05),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.32),
                            ],
                            stops: const [0.0, 0.55, 1.0],
                          ),
                        ),
                      ),
                    ],
                    CustomPaint(
                      painter: _ShimmerSweepPainter(progress: shimmerProgress),
                    ),
                    if (showCenterEmblem)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final emblemSize =
                                  math.min(constraints.maxWidth, constraints.maxHeight) *
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
                                            const Color(0xFF2A1410).withValues(alpha: 0.28),
                                            const Color(0xFF1A1208).withValues(alpha: 0.14),
                                            Colors.transparent,
                                          ],
                                          stops: const [0.0, 0.5, 1.0],
                                        ),
                                      ),
                                    ),
                                    _MajesticCenterEmblem(
                                      progress: animationProgress,
                                      hovered: hovered,
                                      size: emblemSize,
                                    ),
                                  ],
                                ),
                              );
                            },
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
  });

  final bool hovered;
  final double pulse;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final breathe = 0.5 + 0.5 * math.sin(pulse * math.pi * 2);
    return Positioned.fill(
      child: IgnorePointer(
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
      ),
    );
  }
}

class _ShadowPlate extends StatelessWidget {
  const _ShadowPlate({
    required this.lift,
    required this.hovered,
    required this.borderRadius,
  });

  final double lift;
  final bool hovered;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Transform.translate(
        offset: Offset(0, lift + 10),
        child: Transform.scale(
          scale: 0.96,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius + 2),
              color: Colors.black.withValues(alpha: hovered ? 0.55 : 0.4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.65),
                  blurRadius: 24,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MajesticCenterEmblem extends StatelessWidget {
  const _MajesticCenterEmblem({
    required this.progress,
    required this.hovered,
    required this.size,
  });

  final double progress;
  final bool hovered;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MajesticCenterEmblemPainter(
          progress: progress,
          hovered: hovered,
        ),
      ),
    );
  }
}

class _MajesticCenterEmblemPainter extends CustomPainter {
  _MajesticCenterEmblemPainter({required this.progress, required this.hovered});

  final double progress;
  final bool hovered;

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
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);

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
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

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
      if (glow) {
        final glowPaint = Paint()
          ..color = color.withValues(alpha: 0.55)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(jewelCenter, dotRadius * 2.4, glowPaint);
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
      ..color = AppColors.accentGlow.withValues(alpha: 0.55 + pulse * 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
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
    return oldDelegate.progress != progress || oldDelegate.hovered != hovered;
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
