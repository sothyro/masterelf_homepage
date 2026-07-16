import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/majestic_orbital_card_frame.dart';
import '../../home/widgets/field_work_chinese_design.dart';

/// Bagua + Lo Shu orbital overlay — unique to the YUK9 hero medallion.
class Yuk9MetaphysicsOrbits extends StatelessWidget {
  const Yuk9MetaphysicsOrbits({
    super.key,
    required this.progress,
    required this.hovered,
    required this.behind,
    this.extentScale = 1.27,
    this.reduceEffects = false,
  });

  final double progress;
  final bool hovered;
  final bool behind;
  final double extentScale;
  final bool reduceEffects;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Yuk9MetaphysicsOrbitsPainter(
        progress: progress,
        hovered: hovered,
        behind: behind,
        extentScale: extentScale,
        reduceEffects: reduceEffects,
      ),
    );
  }
}

enum _OrbitDepth { behind, front }

/// Later Heaven Bagua order (clockwise from south / top).
const _baguaTrigrams = <List<bool>>[
  [true, false, true], // Li 离 Fire
  [false, false, false], // Kun 坤 Earth
  [true, true, false], // Dui 兑 Lake
  [true, true, true], // Qian 乾 Heaven
  [false, true, false], // Kan 坎 Water
  [false, false, true], // Gen 艮 Mountain
  [true, false, false], // Zhen 震 Thunder
  [false, true, true], // Xun 巽 Wind
];

const _loShuNumbers = <List<int>>[
  [4, 9, 2],
  [3, 5, 7],
  [8, 1, 6],
];

const _loShuChineseNumerals = ['一', '二', '三', '四', '五', '六', '七', '八', '九'];
const _flyingStarPath = [5, 6, 1, 8, 3, 4, 9, 2, 7];

/// Cached glyph painters for orbital characters (avoids per-frame layout).
final Map<String, TextPainter> _orbitTextPainterCache = {};

TextPainter _cachedOrbitTextPainter({
  required String character,
  required double fontSize,
  required Color color,
  FontWeight fontWeight = FontWeight.w600,
  List<Shadow>? shadows,
}) {
  final shadowKey = shadows?.map((s) => s.blurRadius).join(',') ?? '';
  final key = '$character|$fontSize|${color.toARGB32()}|$fontWeight|$shadowKey';
  return _orbitTextPainterCache.putIfAbsent(key, () {
    final painter = TextPainter(
      text: TextSpan(
        text: character,
        style: GoogleFonts.notoSerifSc(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: 1,
          shadows: shadows,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return painter;
  });
}

/// BaZi ten Heavenly Stems (天干).
const _heavenlyStems = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];

/// Qimen Dunjia Eight Gates (八门).
const _qimenEightGates = ['休', '生', '伤', '杜', '景', '死', '惊', '开'];

/// Qimen Three Oddities (三奇) — key strategic stars.
const _qimenThreeOddities = ['乙', '丙', '丁'];

class _OrbitSample {
  const _OrbitSample({required this.point, required this.depth});

  final Offset point;
  final double depth;
}

class _Yuk9MetaphysicsOrbitsPainter extends CustomPainter {
  _Yuk9MetaphysicsOrbitsPainter({
    required this.progress,
    required this.hovered,
    required this.behind,
    required this.extentScale,
    this.reduceEffects = false,
  });

  final double progress;
  final bool hovered;
  final bool behind;
  final double extentScale;
  final bool reduceEffects;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final depth = behind ? _OrbitDepth.behind : _OrbitDepth.front;
    final baseOpacity = hovered ? 1.0 : 0.88;
    final depthFade = depth == _OrbitDepth.front ? 1.0 : 0.55;

    if (depth == _OrbitDepth.behind) {
      _paintCelestialHalo(canvas, center, size, baseOpacity * 0.65);
      _paintLoShuGrid(canvas, size, center, baseOpacity * 0.68);
      _paintGracefulEllipticalOrbit(
        canvas: canvas,
        center: center,
        size: size,
        depth: depth,
        opacity: baseOpacity * 0.55,
      );
      _paintHeavenlyStemOrbit(
        canvas: canvas,
        center: center,
        size: size,
        depth: depth,
        opacity: baseOpacity * 0.42,
      );
      _paintQimenGateOrbit(
        canvas: canvas,
        center: center,
        size: size,
        depth: depth,
        opacity: baseOpacity * 0.38,
      );
    }

    _paintBaguaOctagonOrbit(
      canvas: canvas,
      center: center,
      size: size,
      depth: depth,
      opacity: baseOpacity * depthFade,
      ringScale: 1.0,
      planeTilt: 0.62,
    );

    if (depth == _OrbitDepth.front) {
      _paintGracefulEllipticalOrbit(
        canvas: canvas,
        center: center,
        size: size,
        depth: depth,
        opacity: baseOpacity * 0.82,
      );
      _paintBaguaOctagonOrbit(
        canvas: canvas,
        center: center,
        size: size,
        depth: depth,
        opacity: baseOpacity * 0.38,
        ringScale: 1.12,
        planeTilt: 0.48,
      );
      _paintFlyingStars(canvas, center, size, baseOpacity);
      _paintCardinalSeals(canvas, center, size, baseOpacity);
      _paintHeavenlyStemOrbit(
        canvas: canvas,
        center: center,
        size: size,
        depth: depth,
        opacity: baseOpacity * 0.78,
      );
      _paintQimenGateOrbit(
        canvas: canvas,
        center: center,
        size: size,
        depth: depth,
        opacity: baseOpacity * 0.72,
      );
      _paintQimenOddities(canvas, center, size, baseOpacity * 0.58);
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

    const steps = 140;
    final thetaStart = isFront ? 0.0 : math.pi;
    final points = <Offset>[];
    for (var i = 0; i <= steps; i++) {
      final theta = thetaStart + (i / steps) * math.pi + rotation;
      points.add(_ellipseOrbitPoint(center, rx, ry, tilt, theta));
    }

    final path = _smoothPathThrough(points);
    final ringRect = Rect.fromCenter(center: center, width: rx * 2.2, height: ry * 2.2);

    if (isFront) {
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 11
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..color = AppColors.accentGlow.withValues(alpha: opacity * 0.26)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
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

  void _paintLoShuGrid(
    Canvas canvas,
    Size size,
    Offset center,
    double opacity,
  ) {
    final breath = majesticOrbitalRingBreath(progress, phase: 0.4, amount: 0.02);
    final gridSpan = math.min(size.width, size.height) * 0.54 * extentScale * breath;
    final cell = gridSpan / 3;
    final origin = Offset(center.dx - gridSpan / 2, center.dy - gridSpan / 2);
    const planeTilt = 0.28;

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.accent.withValues(alpha: opacity * 0.48);

    for (var i = 0; i <= 3; i++) {
      final o = i * cell;
      _drawTiltedLine(
        canvas,
        _tiltPoint(origin + Offset(o, 0), center, gridSpan, planeTilt),
        _tiltPoint(origin + Offset(o, gridSpan), center, gridSpan, planeTilt),
        linePaint,
      );
      _drawTiltedLine(
        canvas,
        _tiltPoint(origin + Offset(0, o), center, gridSpan, planeTilt),
        _tiltPoint(origin + Offset(gridSpan, o), center, gridSpan, planeTilt),
        linePaint,
      );
    }

    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < 3; col++) {
        final number = _loShuNumbers[row][col];
        final palace = _tiltPoint(
          Offset(origin.dx + col * cell + cell / 2, origin.dy + row * cell + cell / 2),
          center,
          gridSpan,
          planeTilt,
        );
        if (number == 5) {
          canvas.drawCircle(
            palace,
            cell * 0.12,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.1
              ..color = AppColors.accentLight.withValues(alpha: opacity * 0.5),
          );
        }
        _paintLoShuNumeral(canvas, palace, number, opacity * (number == 5 ? 0.72 : 0.44));
      }
    }
  }

  Offset _tiltPoint(Offset p, Offset center, double span, double tilt) {
    final nx = (p.dx - center.dx) / span;
    final ny = (p.dy - center.dy) / span;
    return Offset(center.dx + nx * span, center.dy + ny * span * math.cos(tilt) + span * 0.04 * ny);
  }

  void _drawTiltedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    canvas.drawLine(a, b, paint);
  }

  void _paintLoShuNumeral(
    Canvas canvas,
    Offset center,
    int number,
    double opacity,
  ) {
    final textPainter = _cachedOrbitTextPainter(
      character: _loShuChineseNumerals[number - 1],
      fontSize: 10.5,
      fontWeight: FontWeight.w700,
      color: AppColors.accent.withValues(alpha: opacity),
      shadows: [
        Shadow(
          color: AppColors.accentGlow.withValues(alpha: opacity * 0.4),
          blurRadius: 5,
        ),
      ],
    );
    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
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
      _drawOctagonEdge(canvas, a.point, b.point, edgeOpacity, isFront, midDepth / radius);
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
    double depthNorm,
  ) {
    if (front) {
      canvas.drawLine(
        a,
        b,
        Paint()
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round
          ..color = AppColors.accentGlow.withValues(alpha: opacity * 0.34)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
      );
    }

    canvas.drawLine(
      a,
      b,
      Paint()
        ..strokeWidth = front ? 3.0 : 1.8
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

    if (front && depthNorm > 0.15) {
      canvas.drawLine(
        a,
        b,
        Paint()
          ..strokeWidth = 0.9
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFFFFF8E7).withValues(alpha: opacity * 0.32),
      );
    }
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

    final lineW = 13.0;
    final gap = 3.8;
    final barH = 2.0;
    final brokenGap = 3.4;
    final paint = Paint()
      ..color = FieldWorkChinesePalette.ricePaper.withValues(alpha: opacity * 0.94)
      ..strokeWidth = barH
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(
      Offset.zero,
      lineW * 0.8,
      Paint()
        ..color = AppColors.accentGlow.withValues(alpha: opacity * 0.16)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
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

  void _paintFlyingStars(
    Canvas canvas,
    Offset center,
    Size size,
    double opacity,
  ) {
    final gridSpan = math.min(size.width, size.height) * 0.54 * extentScale;
    final cell = gridSpan / 3;
    final origin = Offset(center.dx - gridSpan / 2, center.dy - gridSpan / 2);
    const planeTilt = 0.28;

    Offset palaceCenter(int star) {
      for (var row = 0; row < 3; row++) {
        for (var col = 0; col < 3; col++) {
          if (_loShuNumbers[row][col] == star) {
            return _tiltPoint(
              Offset(origin.dx + col * cell + cell / 2, origin.dy + row * cell + cell / 2),
              center,
              gridSpan,
              planeTilt,
            );
          }
        }
      }
      return center;
    }

    for (final (speed, phase, alpha, hue) in [
      (1.0, 0.2, 1.0, 0),
      (-0.75, math.pi * 0.65, 0.8, 1),
      (0.55, math.pi * 1.35, 0.62, 2),
    ]) {
      _paintFlyingStarParticle(
        canvas,
        palaceCenter: palaceCenter,
        travel: majesticOrbitalGracefulRotation(progress, speed: speed, phase: phase),
        opacity: opacity * alpha,
        hueShift: hue,
      );
    }
  }

  void _paintFlyingStarParticle(
    Canvas canvas, {
    required Offset Function(int star) palaceCenter,
    required double travel,
    required double opacity,
    required int hueShift,
  }) {
    final pathLen = _flyingStarPath.length;
    final tSeg = (travel / (math.pi * 2)) % 1.0 * pathLen;
    final idx = tSeg.floor() % pathLen;
    final frac = tSeg - idx;
    final from = palaceCenter(_flyingStarPath[idx]);
    final to = palaceCenter(_flyingStarPath[(idx + 1) % pathLen]);
    final pos = Offset.lerp(from, to, frac)!;

    final starColor = switch (hueShift) {
      0 => AppColors.accentLight,
      1 => FieldWorkChinesePalette.jadeMuted,
      _ => const Color(0xFFFFF4C2),
    };

    final trailPaint = Paint()
      ..color = starColor.withValues(alpha: opacity * 0.45)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    for (var i = 1; i <= 10; i++) {
      final fade = 1 - i / 10;
      final tp = Offset.lerp(from, pos, 1 - i * 0.1)!;
      canvas.drawCircle(tp, 2.8 * fade, trailPaint);
    }

    canvas.drawCircle(
      pos,
      9,
      Paint()
        ..color = AppColors.accentGlow.withValues(alpha: opacity * 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    canvas.drawCircle(pos, 4.6, Paint()..color = starColor.withValues(alpha: opacity * 0.92));
    canvas.drawCircle(pos, 2.2, Paint()..color = const Color(0xFFFFF8E7));
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
      speed: isFront ? -0.24 : 0.2,
      phase: isFront ? math.pi * 0.2 : math.pi * 1.1,
    );
    final breath = majesticOrbitalRingBreath(progress, phase: 1.05, amount: 0.018);
    final radius = math.min(size.width, size.height) * 0.465 * extentScale * breath;
    const planeTilt = 0.5;

    for (var i = 0; i < _qimenEightGates.length; i++) {
      final theta = i * (math.pi / 4) - math.pi / 2;
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
        accent: FieldWorkChinesePalette.jadeMuted,
        outward: sample.point - center,
      );
    }
  }

  void _paintQimenOddities(
    Canvas canvas,
    Offset center,
    Size size,
    double opacity,
  ) {
    final rotation = majesticOrbitalGracefulRotation(progress, speed: 0.42, phase: 1.7);
    final radius = math.min(size.width, size.height) * 0.28 * extentScale;
    const planeTilt = 0.45;

    for (var i = 0; i < _qimenThreeOddities.length; i++) {
      final theta = i * (math.pi * 2 / 3) + math.pi / 6;
      final sample = _sampleTiltedOrbit(
        center: center,
        theta: theta,
        radius: radius,
        rotation: rotation,
        planeTilt: planeTilt,
      );
      if (sample.depth < 0) continue;
      final depthNorm = (sample.depth / radius).clamp(-1.0, 1.0);
      final glyphOpacity = opacity * (0.55 + 0.45 * (depthNorm + 1) / 2);
      _paintOrbitalCharacter(
        canvas,
        sample.point,
        _qimenThreeOddities[i],
        fontSize: 9.5,
        opacity: glyphOpacity,
        accent: const Color(0xFFFFF4C2),
        outward: sample.point - center,
        showHalo: true,
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
    bool showHalo = false,
  }) {
    if (showHalo && !reduceEffects) {
      canvas.drawCircle(
        center,
        fontSize * 0.85,
        Paint()
          ..color = accent.withValues(alpha: opacity * 0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
    }

    final angle = math.atan2(outward.dy, outward.dx);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle + math.pi / 2);

    final textPainter = _cachedOrbitTextPainter(
      character: character,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: accent.withValues(alpha: opacity),
      shadows: [
        Shadow(
          color: AppColors.accentGlow.withValues(alpha: opacity * 0.35),
          blurRadius: 6,
        ),
      ],
    );
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
    canvas.restore();
  }

  void _paintCardinalSeals(
    Canvas canvas,
    Offset center,
    Size size,
    double opacity,
  ) {
    final breath = majesticOrbitalRingBreath(progress, phase: math.pi * 1.1, amount: 0.02);
    final radius = math.min(size.width, size.height) * 0.48 * extentScale * breath;
    const planeTilt = 0.55;

    for (var i = 0; i < 4; i++) {
      final sample = _sampleTiltedOrbit(
        center: center,
        theta: i * math.pi / 2 - math.pi / 2,
        radius: radius,
        rotation: majesticOrbitalGracefulRotation(progress, speed: 0.2, phase: 0.5),
        planeTilt: planeTilt,
      );
      if (sample.depth < 0) continue;
      final sealOpacity = opacity * (0.65 + 0.35 * ((sample.depth / radius).clamp(-1.0, 1.0) + 1) / 2);
      final pos = sample.point;

      canvas.drawCircle(
        pos,
        8,
        Paint()
          ..color = AppColors.accent.withValues(alpha: sealOpacity * 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
      );
      canvas.drawCircle(
        pos,
        4.0,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.1
          ..color = AppColors.accentLight.withValues(alpha: sealOpacity * 0.88),
      );
      canvas.drawCircle(
        pos,
        2.4,
        Paint()..color = const Color(0xFFFFF8E7).withValues(alpha: sealOpacity * 0.92),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _Yuk9MetaphysicsOrbitsPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.hovered != hovered ||
        oldDelegate.behind != behind ||
        oldDelegate.extentScale != extentScale ||
        oldDelegate.reduceEffects != reduceEffects;
  }
}
