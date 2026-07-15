import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/home/widgets/field_work_chinese_design.dart';
import '../theme/app_theme.dart';
import 'majestic_orbital_card_frame.dart';

/// Dialog-tuned YUK9 metaphysics orbits — single paint pass, no MaskFilter.
class SocialPopupYuk9Orbits extends StatelessWidget {
  const SocialPopupYuk9Orbits({
    super.key,
    required this.progress,
    required this.hovered,
    this.extentScale = 1.27,
    this.child,
  });

  final double progress;
  final bool hovered;
  final double extentScale;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SocialPopupYuk9OrbitsPainter(
        progress: progress,
        hovered: hovered,
        extentScale: extentScale,
      ),
      child: child ?? const SizedBox.expand(),
    );
  }
}

enum _OrbitDepth { behind, front }

/// Later Heaven Bagua order (clockwise from south / top).
const _baguaTrigrams = <List<bool>>[
  [true, false, true],
  [false, false, false],
  [true, true, false],
  [true, true, true],
  [false, true, false],
  [false, false, true],
  [true, false, false],
  [false, true, true],
];

const _heavenlyStems = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
const _qimenEightGates = ['休', '生', '伤', '杜', '景', '死', '惊', '开'];

const int _opacityBuckets = 12;

/// Quantize animated opacity so text cache keys stay bounded.
double _quantizeOpacity(double opacity) {
  final clamped = opacity.clamp(0.0, 1.0);
  final bucket = (clamped * (_opacityBuckets - 1)).round();
  return bucket / (_opacityBuckets - 1);
}

final Map<String, TextPainter> _dialogOrbitTextCache = {};

TextPainter _cachedDialogOrbitText({
  required String character,
  required double fontSize,
  required double opacity,
  required Color accent,
  FontWeight fontWeight = FontWeight.w600,
}) {
  final q = _quantizeOpacity(opacity);
  final key = '$character|$fontSize|$q|${accent.toARGB32()}|$fontWeight';
  return _dialogOrbitTextCache.putIfAbsent(key, () {
    final painter = TextPainter(
      text: TextSpan(
        text: character,
        style: GoogleFonts.notoSerifSc(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: accent.withValues(alpha: q),
          height: 1,
          shadows: [
            Shadow(
              color: AppColors.accentGlow.withValues(alpha: q * 0.35),
              blurRadius: 4,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return painter;
  });
}

class _OrbitSample {
  const _OrbitSample({required this.point, required this.depth});

  final Offset point;
  final double depth;
}

class _SocialPopupYuk9OrbitsPainter extends CustomPainter {
  _SocialPopupYuk9OrbitsPainter({
    required this.progress,
    required this.hovered,
    required this.extentScale,
  });

  final double progress;
  final bool hovered;
  final double extentScale;

  static const _pathSteps = 56;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseOpacity = hovered ? 1.0 : 0.88;

    _paintCelestialHalo(canvas, center, size, baseOpacity * 0.65);

    for (final depth in _OrbitDepth.values) {
      final depthFade = depth == _OrbitDepth.front ? 1.0 : 0.55;
      _paintGracefulEllipticalOrbit(
        canvas: canvas,
        center: center,
        size: size,
        depth: depth,
        opacity: baseOpacity * (depth == _OrbitDepth.front ? 0.78 : 0.52),
      );
      _paintBaguaOctagonOrbit(
        canvas: canvas,
        center: center,
        size: size,
        depth: depth,
        opacity: baseOpacity * depthFade,
        ringScale: depth == _OrbitDepth.front ? 1.08 : 1.0,
        planeTilt: depth == _OrbitDepth.front ? 0.48 : 0.62,
      );
      if (depth == _OrbitDepth.front) {
        _paintHeavenlyStemOrbit(
          canvas: canvas,
          center: center,
          size: size,
          depth: depth,
          opacity: baseOpacity * 0.72,
        );
        _paintQimenGateOrbit(
          canvas: canvas,
          center: center,
          size: size,
          depth: depth,
          opacity: baseOpacity * 0.66,
        );
      }
    }
  }

  _OrbitSample _sampleTiltedOrbit({
    required Offset center,
    required double theta,
    required double radius,
    required double rotation,
    required double planeTilt,
  }) {
    final angle = theta + rotation;
    final x3 = math.cos(angle) * radius;
    final z3 = math.sin(angle) * radius;
    final y2 = z3 * math.sin(planeTilt);
    final depth = z3 * math.cos(planeTilt);
    return _OrbitSample(
      point: Offset(center.dx + x3, center.dy + y2),
      depth: depth,
    );
  }

  void _paintCelestialHalo(
    Canvas canvas,
    Offset center,
    Size size,
    double opacity,
  ) {
    final breath = majesticOrbitalRingBreath(progress, phase: 0.15, amount: 0.022);
    final radius = math.min(size.width, size.height) * 0.46 * extentScale * breath;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.accentGlow.withValues(alpha: opacity * 0.2),
            AppColors.accent.withValues(alpha: opacity * 0.08),
            Colors.transparent,
          ],
          stops: const [0.72, 0.88, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  Offset _ellipseOrbitPoint(
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

  Path _smoothPathThrough(List<Offset> points) {
    final path = Path();
    if (points.isEmpty) return path;
    if (points.length == 1) {
      path.addOval(Rect.fromCircle(center: points.first, radius: 0.5));
      return path;
    }

    path.moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final p0 = points[i == 0 ? i : i - 1];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = points[i + 2 < points.length ? i + 2 : i + 1];
      final cp1 = Offset(
        p1.dx + (p2.dx - p0.dx) / 6,
        p1.dy + (p2.dy - p0.dy) / 6,
      );
      final cp2 = Offset(
        p2.dx - (p3.dx - p1.dx) / 6,
        p2.dy - (p3.dy - p1.dy) / 6,
      );
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  void _paintGracefulEllipticalOrbit({
    required Canvas canvas,
    required Offset center,
    required Size size,
    required _OrbitDepth depth,
    required double opacity,
  }) {
    final isFront = depth == _OrbitDepth.front;
    final sway = math.sin(progress * math.pi * 2 + 0.35) * 0.032;
    final tilt = 0.5 + sway;
    final rotation = majesticOrbitalGracefulRotation(
      progress,
      speed: 0.42,
      phase: 0.55,
    );
    final breath = majesticOrbitalRingBreath(
      progress,
      phase: 0.85,
      amount: 0.016,
    );
    final rx = math.min(size.width, size.height) * 0.435 * extentScale * breath;
    final ry = rx * 0.48;

    final thetaStart = isFront ? 0.0 : math.pi;
    final points = <Offset>[];
    for (var i = 0; i <= _pathSteps; i++) {
      final theta = thetaStart + (i / _pathSteps) * math.pi + rotation;
      points.add(_ellipseOrbitPoint(center, rx, ry, tilt, theta));
    }

    final path = _smoothPathThrough(points);
    final ringRect = Rect.fromCenter(center: center, width: rx * 2.2, height: ry * 2.2);

    if (isFront) {
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = AppColors.accentGlow.withValues(alpha: opacity * 0.22),
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isFront ? 2.0 : 1.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: isFront
              ? [
                  AppColors.accent.withValues(alpha: opacity * 0.35),
                  AppColors.accentLight.withValues(alpha: opacity * 0.92),
                  const Color(0xFFFFF4C2).withValues(alpha: opacity * 0.98),
                  AppColors.accentLight.withValues(alpha: opacity * 0.92),
                  AppColors.accent.withValues(alpha: opacity * 0.35),
                ]
              : [
                  AppColors.accent.withValues(alpha: opacity * 0.38),
                  AppColors.accent.withValues(alpha: opacity * 0.62),
                  AppColors.accent.withValues(alpha: opacity * 0.38),
                ],
          stops: isFront
              ? const [0.0, 0.28, 0.5, 0.72, 1.0]
              : const [0.0, 0.5, 1.0],
        ).createShader(ringRect),
    );
  }

  void _paintBaguaOctagonOrbit({
    required Canvas canvas,
    required Offset center,
    required Size size,
    required _OrbitDepth depth,
    required double opacity,
    required double ringScale,
    required double planeTilt,
  }) {
    final rotation = majesticOrbitalGracefulRotation(
      progress,
      speed: depth == _OrbitDepth.front ? 0.32 : -0.26,
      phase: depth == _OrbitDepth.front ? 0.0 : math.pi,
    );
    final breath = majesticOrbitalRingBreath(
      progress,
      phase: depth == _OrbitDepth.front ? 0.8 : math.pi * 0.5,
      amount: 0.02,
    );
    final radius =
        math.min(size.width, size.height) * 0.41 * extentScale * breath * ringScale;
    final isFront = depth == _OrbitDepth.front;

    final samples = List.generate(8, (i) {
      return _sampleTiltedOrbit(
        center: center,
        theta: i * math.pi / 4 - math.pi / 2,
        radius: radius,
        rotation: rotation,
        planeTilt: planeTilt,
      );
    });

    for (var i = 0; i < 8; i++) {
      final a = samples[i];
      final b = samples[(i + 1) % 8];
      final midDepth = (a.depth + b.depth) / 2;
      final onFrontHalf = midDepth >= 0;
      if (onFrontHalf != isFront) continue;

      final edgeOpacity = opacity * (0.55 + 0.45 * ((midDepth / radius).clamp(-1.0, 1.0) + 1) / 2);
      _drawOctagonEdge(canvas, a.point, b.point, edgeOpacity, isFront);
    }

    if (ringScale <= 1.02) {
      for (var i = 0; i < 8; i++) {
        final sample = samples[i];
        final onFrontHalf = sample.depth >= 0;
        if (onFrontHalf != isFront) continue;
        final glyphOpacity = opacity * (0.6 + 0.4 * ((sample.depth / radius).clamp(-1.0, 1.0) + 1) / 2);
        _drawTrigramGlyph(
          canvas,
          center: sample.point,
          outward: sample.point - center,
          lines: _baguaTrigrams[i],
          opacity: glyphOpacity,
          depthScale: 0.75 + 0.25 * ((sample.depth / radius).clamp(-1.0, 1.0) + 1) / 2,
        );
      }
    }
  }

  void _drawOctagonEdge(
    Canvas canvas,
    Offset a,
    Offset b,
    double opacity,
    bool front,
  ) {
    if (front) {
      canvas.drawLine(
        a,
        b,
        Paint()
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round
          ..color = AppColors.accentGlow.withValues(alpha: opacity * 0.28),
      );
    }

    canvas.drawLine(
      a,
      b,
      Paint()
        ..strokeWidth = front ? 2.6 : 1.6
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          colors: [
            AppColors.accent.withValues(alpha: opacity * 0.5),
            const Color(0xFFFFF4C2).withValues(alpha: opacity * (front ? 0.98 : 0.55)),
            AppColors.accentLight.withValues(alpha: opacity * (front ? 0.9 : 0.52)),
            AppColors.accent.withValues(alpha: opacity * 0.5),
          ],
          stops: const [0.0, 0.35, 0.65, 1.0],
        ).createShader(Rect.fromPoints(a, b)),
    );
  }

  void _drawTrigramGlyph(
    Canvas canvas, {
    required Offset center,
    required Offset outward,
    required List<bool> lines,
    required double opacity,
    required double depthScale,
  }) {
    final angle = math.atan2(outward.dy, outward.dx);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle + math.pi / 2);
    canvas.scale(depthScale);

    const lineW = 13.0;
    const gap = 3.8;
    const barH = 2.0;
    const brokenGap = 3.4;
    final q = _quantizeOpacity(opacity);
    final paint = Paint()
      ..color = FieldWorkChinesePalette.ricePaper.withValues(alpha: q * 0.94)
      ..strokeWidth = barH
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      Offset.zero,
      lineW * 0.8,
      Paint()..color = AppColors.accentGlow.withValues(alpha: q * 0.16),
    );

    for (var i = 0; i < 3; i++) {
      final y = (i - 1) * gap;
      if (lines[i]) {
        canvas.drawLine(Offset(-lineW / 2, y), Offset(lineW / 2, y), paint);
      } else {
        canvas.drawLine(Offset(-lineW / 2, y), Offset(-brokenGap / 2, y), paint);
        canvas.drawLine(Offset(brokenGap / 2, y), Offset(lineW / 2, y), paint);
      }
    }
    canvas.restore();
  }

  void _paintHeavenlyStemOrbit({
    required Canvas canvas,
    required Offset center,
    required Size size,
    required _OrbitDepth depth,
    required double opacity,
  }) {
    final isFront = depth == _OrbitDepth.front;
    final rotation = majesticOrbitalGracefulRotation(
      progress,
      speed: isFront ? 0.18 : -0.14,
      phase: isFront ? 0.35 : math.pi * 0.8,
    );
    final breath = majesticOrbitalRingBreath(progress, phase: 0.25, amount: 0.018);
    final radius = math.min(size.width, size.height) * 0.52 * extentScale * breath;
    const planeTilt = 0.58;

    for (var i = 0; i < _heavenlyStems.length; i++) {
      final theta = i * (math.pi * 2 / _heavenlyStems.length) - math.pi / 2;
      final sample = _sampleTiltedOrbit(
        center: center,
        theta: theta,
        radius: radius,
        rotation: rotation,
        planeTilt: planeTilt,
      );
      final onFrontHalf = sample.depth >= 0;
      if (onFrontHalf != isFront) continue;

      final depthNorm = (sample.depth / radius).clamp(-1.0, 1.0);
      final glyphOpacity = opacity * (0.5 + 0.5 * (depthNorm + 1) / 2);
      _paintOrbitalCharacter(
        canvas,
        sample.point,
        _heavenlyStems[i],
        fontSize: 11.5,
        opacity: glyphOpacity,
        accent: AppColors.accentLight,
        outward: sample.point - center,
      );
    }
  }

  void _paintQimenGateOrbit({
    required Canvas canvas,
    required Offset center,
    required Size size,
    required _OrbitDepth depth,
    required double opacity,
  }) {
    final isFront = depth == _OrbitDepth.front;
    final rotation = majesticOrbitalGracefulRotation(
      progress,
      speed: isFront ? 0.14 : -0.11,
      phase: isFront ? 1.1 : math.pi * 1.4,
    );
    final breath = majesticOrbitalRingBreath(progress, phase: 0.6, amount: 0.016);
    final radius = math.min(size.width, size.height) * 0.58 * extentScale * breath;
    const planeTilt = 0.52;

    for (var i = 0; i < _qimenEightGates.length; i++) {
      final theta = i * (math.pi * 2 / _qimenEightGates.length) - math.pi / 2;
      final sample = _sampleTiltedOrbit(
        center: center,
        theta: theta,
        radius: radius,
        rotation: rotation,
        planeTilt: planeTilt,
      );
      final onFrontHalf = sample.depth >= 0;
      if (onFrontHalf != isFront) continue;

      final depthNorm = (sample.depth / radius).clamp(-1.0, 1.0);
      final glyphOpacity = opacity * (0.48 + 0.52 * (depthNorm + 1) / 2);
      _paintOrbitalCharacter(
        canvas,
        sample.point,
        _qimenEightGates[i],
        fontSize: 10.5,
        opacity: glyphOpacity,
        accent: AppColors.accentLight,
        outward: sample.point - center,
      );
    }
  }

  void _paintOrbitalCharacter(
    Canvas canvas,
    Offset center,
    String character, {
    required double fontSize,
    required double opacity,
    required Color accent,
    required Offset outward,
  }) {
    final angle = math.atan2(outward.dy, outward.dx);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle + math.pi / 2);

    final textPainter = _cachedDialogOrbitText(
      character: character,
      fontSize: fontSize,
      opacity: opacity,
      accent: accent,
    );
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SocialPopupYuk9OrbitsPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.hovered != hovered ||
        oldDelegate.extentScale != extentScale;
  }
}
