import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../config/app_content.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../../utils/mobile_web_performance.dart';
import '../../../widgets/majestic_orbital_card_frame.dart';
import '../../home/widgets/field_work_chinese_design.dart';
import 'apps_yuk9_brand.dart';
import 'apps_yuk9_metaphysics_orbits.dart';

/// Hero medallion: YUK9 emblem with Chinese metaphysics orbits and encroaching frame.
class AppsHeroMedallion extends StatefulWidget {
  const AppsHeroMedallion({super.key});

  static double coreSizeForWidth(double width) {
    if (width < Breakpoints.mobile) {
      return (width * 0.56).clamp(220.0, 268.0);
    }
    if (width < Breakpoints.tablet) {
      return (width * 0.34).clamp(280.0, 320.0);
    }
    return (width * 0.28).clamp(310.0, 360.0);
  }

  static double orbitPad(bool isNarrow) => 57.0;

  @override
  State<AppsHeroMedallion> createState() => _AppsHeroMedallionState();
}

class _AppsHeroMedallionState extends State<AppsHeroMedallion>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _inViewport = true;
  bool _orbitAnimationEnabled = false;
  bool _orbitAnimationScheduled = false;
  late final AnimationController _cycle;

  static const _orbitExtentScale = 1.27;
  static const _idleWobbleStrength = 0.62;
  static const _hoverWobbleStrength = 1.0;
  static const _idleWobbleSpeed = 0.82;

  bool _permanentlyStatic(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    return mq != null && mq.disableAnimations;
  }

  bool _showStaticMedallion(BuildContext context) {
    if (_permanentlyStatic(context)) return true;
    return MobileWebPerformance.isMobileWeb(context) && !_orbitAnimationEnabled;
  }

  @override
  void initState() {
    super.initState();
    _cycle = AnimationController(
      vsync: this,
      duration: kMajesticOrbitalCycleDuration,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _inViewport && _orbitAnimationEnabled) _cycle.repeat();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_permanentlyStatic(context)) return;

    if (!MobileWebPerformance.isMobileWeb(context)) {
      if (!_orbitAnimationEnabled) {
        _orbitAnimationEnabled = true;
        if (_inViewport && !_cycle.isAnimating) _cycle.repeat();
      }
      return;
    }

    if (_orbitAnimationScheduled || _orbitAnimationEnabled) return;
    _orbitAnimationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(MobileWebPerformance.heroMedallionAnimationDefer(), () {
        if (!mounted || _orbitAnimationEnabled) return;
        setState(() => _orbitAnimationEnabled = true);
        if (_inViewport && !_cycle.isAnimating) _cycle.repeat();
      });
    });
  }

  @override
  void dispose() {
    VisibilityDetectorController.instance.forget(
      const ValueKey<String>('apps-hero-medallion'),
    );
    _cycle.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    final visible = info.visibleFraction > 0.08;
    if (visible == _inViewport) return;
    _inViewport = visible;
    if (visible) {
      if (!_cycle.isAnimating) _cycle.repeat();
    } else {
      _cycle.stop();
    }
  }

  static double _orbitPad(bool isNarrow) => AppsHeroMedallion.orbitPad(isNarrow);

  @override
  Widget build(BuildContext context) {
    if (_showStaticMedallion(context)) {
      return _StaticAppsHeroMedallion(hovered: _hovered);
    }

    return VisibilityDetector(
      key: const ValueKey<String>('apps-hero-medallion'),
      onVisibilityChanged: _onVisibilityChanged,
      child: TickerMode(
        enabled: _inViewport,
        child: LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < Breakpoints.mobile;
        final core = AppsHeroMedallion.coreSizeForWidth(constraints.maxWidth);
        final pad = _orbitPad(isNarrow);
        final stage = core + pad * 2;
        final l10n = AppLocalizations.of(context)!;
        final cornerRadius = core * 0.145;
        final encroach = core * 0.045;
        final frameBand = core * 0.065;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MouseRegion(
              onEnter: (_) => setState(() => _hovered = true),
              onExit: (_) => setState(() => _hovered = false),
              child: SizedBox(
                width: stage,
                height: stage,
                child: AnimatedBuilder(
                  animation: _cycle,
                  builder: (context, _) {
                    final t = _cycle.value;
                    final wobbleStrength = _hovered
                        ? _hoverWobbleStrength
                        : _idleWobbleStrength;
                    final wobbleSpeed = _hovered
                        ? kMajesticHoverWobbleSpeed
                        : _idleWobbleSpeed;
                    final wobbleX =
                        majesticOrbitalHoverTiltWobble(
                          t,
                          phase: 0.4,
                          speed: wobbleSpeed,
                        ) *
                            wobbleStrength +
                        (_hovered ? -0.014 : -0.007);
                    final wobbleY =
                        majesticOrbitalHoverTiltWobble(
                          t,
                          phase: 1.85,
                          speed: wobbleSpeed,
                        ) *
                            wobbleStrength +
                        (_hovered ? 0.02 : 0.01);
                    final wobbleZ = majesticOrbitalHoverTiltWobble(
                      t,
                      phase: 2.55,
                      speed: wobbleSpeed * 0.9,
                    ) *
                        wobbleStrength *
                        0.42;
                    final lift = majesticOrbitalHoverFloat(
                      t,
                      phase: 0.9,
                      speed: wobbleSpeed,
                    ) *
                        wobbleStrength +
                        (_hovered ? -5.0 : -2.5);

                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Yuk9MetaphysicsOrbits(
                              progress: t,
                              hovered: _hovered,
                              behind: true,
                              extentScale: _orbitExtentScale,
                              reduceEffects: MobileWebPerformance.isMobileWeb(context),
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, lift),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.0014)
                              ..rotateX(wobbleX)
                              ..rotateY(wobbleY)
                              ..rotateZ(wobbleZ),
                            child: _Yuk9MedallionCore(
                              size: core,
                              cornerRadius: cornerRadius,
                              encroach: encroach,
                              frameBand: frameBand,
                              hovered: _hovered,
                              qiPulse: t,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Yuk9MetaphysicsOrbits(
                              progress: t,
                              hovered: _hovered,
                              behind: false,
                              extentScale: _orbitExtentScale,
                              reduceEffects: MobileWebPerformance.isMobileWeb(context),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            // Mobile: pull brand lockup up into orbit padding so it sits closer
            // to the emblem (viewport-based, not LayoutBuilder width).
            if (Breakpoints.isMobile(MediaQuery.sizeOf(context).width))
              Transform.translate(
                offset: const Offset(0, -36),
                child: MasterElfYuk9ProBrandTitle(
                  systemName: l10n.masterElfSystem,
                  subtitle: l10n.appsHeroBrandSubtitle,
                  isNarrow: true,
                ),
              )
            else ...[
              const SizedBox(height: 26),
              MasterElfYuk9ProBrandTitle(
                systemName: l10n.masterElfSystem,
                subtitle: l10n.appsHeroBrandSubtitle,
                isNarrow: false,
              ),
            ],
          ],
        );
      },
    ),
      ),
    );
  }
}

/// Lightweight hero placeholder — same stage size as animated version, no orbits yet.
class _StaticAppsHeroMedallion extends StatelessWidget {
  const _StaticAppsHeroMedallion({required this.hovered});

  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < Breakpoints.mobile;
        final core = AppsHeroMedallion.coreSizeForWidth(constraints.maxWidth);
        final pad = AppsHeroMedallion.orbitPad(isNarrow);
        final stage = core + pad * 2;
        final l10n = AppLocalizations.of(context)!;
        final cornerRadius = core * 0.145;
        final encroach = core * 0.045;
        final frameBand = core * 0.065;
        final isMobile = Breakpoints.isMobile(MediaQuery.sizeOf(context).width);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: stage,
              height: stage,
              child: Center(
                child: _Yuk9MedallionCore(
                  size: core,
                  cornerRadius: cornerRadius,
                  encroach: encroach,
                  frameBand: frameBand,
                  hovered: hovered,
                  qiPulse: 0,
                ),
              ),
            ),
            if (isMobile)
              Transform.translate(
                offset: const Offset(0, -36),
                child: MasterElfYuk9ProBrandTitle(
                  systemName: l10n.masterElfSystem,
                  subtitle: l10n.appsHeroBrandSubtitle,
                  isNarrow: true,
                ),
              )
            else ...[
              const SizedBox(height: 26),
              MasterElfYuk9ProBrandTitle(
                systemName: l10n.masterElfSystem,
                subtitle: l10n.appsHeroBrandSubtitle,
                isNarrow: false,
              ),
            ],
          ],
        );
      },
    );
  }
}

class _Yuk9MedallionCore extends StatelessWidget {
  const _Yuk9MedallionCore({
    required this.size,
    required this.cornerRadius,
    required this.encroach,
    required this.frameBand,
    required this.hovered,
    required this.qiPulse,
  });

  final double size;
  final double cornerRadius;
  final double encroach;
  final double frameBand;
  final bool hovered;
  final double qiPulse;

  @override
  Widget build(BuildContext context) {
    final cacheWidth = MobileWebPerformance.devicePixelCacheWidth(context, size);
    final filterQuality = MobileWebPerformance.imageFilterQuality(context);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (hovered)
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.18),
                    const Color(0xFFB83232).withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
              child: SizedBox(width: size * 1.05, height: size * 1.05),
            ),
          SizedBox(
            width: size,
            height: size,
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: hovered
                    ? [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.28),
                          blurRadius: 36,
                          spreadRadius: -6,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.45),
                          blurRadius: 24,
                          offset: const Offset(0, 14),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
              ),
              child: Image.asset(
                AppContent.assetYuk9Icon,
                fit: BoxFit.contain,
                cacheWidth: cacheWidth,
                filterQuality: filterQuality,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported_outlined,
                  size: size * 0.2,
                  color: AppColors.accent.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _MetaphysicsEncroachingFramePainter(
                  cornerRadius: cornerRadius,
                  encroach: encroach,
                  frameBand: frameBand,
                  hovered: hovered,
                  qiPulse: qiPulse,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Later Heaven trigram ticks for the eight frame positions.
const _frameTrigrams = <List<bool>>[
  [true, false, true], // Li
  [false, false, false], // Kun
  [true, true, false], // Dui
  [true, true, true], // Qian
  [false, true, false], // Kan
  [false, false, true], // Gen
  [true, false, false], // Zhen
  [false, true, true], // Xun
];

class _MetaphysicsEncroachingFramePainter extends CustomPainter {
  _MetaphysicsEncroachingFramePainter({
    required this.cornerRadius,
    required this.encroach,
    required this.frameBand,
    required this.hovered,
    required this.qiPulse,
  });

  final double cornerRadius;
  final double encroach;
  final double frameBand;
  final bool hovered;
  final double qiPulse;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final frameRadius = (cornerRadius - encroach * 0.35).clamp(6.0, cornerRadius);
    final frameRect = rect.deflate(encroach);
    final rrect = RRect.fromRectAndRadius(frameRect, Radius.circular(frameRadius));
    final path = Path()..addRRect(rrect);

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = frameBand
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            FieldWorkChinesePalette.ricePaper.withValues(alpha: hovered ? 0.92 : 0.78),
            AppColors.accentLight.withValues(alpha: hovered ? 0.9 : 0.75),
            AppColors.accent.withValues(alpha: hovered ? 0.88 : 0.72),
            const Color(0xFF5C3A18).withValues(alpha: hovered ? 0.9 : 0.78),
          ],
          stops: const [0.0, 0.3, 0.62, 1.0],
        ).createShader(frameRect),
    );

    _paintHuiwenFretBand(canvas, rrect, frameBand);
    _paintBaguaTrigramTicks(canvas, frameRect);
    _paintDoubleCornerBrackets(canvas, frameRect);
    _paintQiPulse(canvas, path, frameRect, frameBand);
  }

  void _paintHuiwenFretBand(Canvas canvas, RRect rrect, double band) {
    final inset = band * 0.42;
    final inner = rrect.deflate(inset);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9
      ..color = AppColors.accent.withValues(alpha: hovered ? 0.55 : 0.38);

    final u = band * 0.85;
    final g = u * 0.35;
    final corners = [
      Offset(inner.left, inner.top),
      Offset(inner.right - u, inner.top),
      Offset(inner.right - u, inner.bottom - u),
      Offset(inner.left, inner.bottom - u),
    ];

    for (final origin in corners) {
      final pts = <Offset>[
        origin + Offset(0, u),
        origin + Offset(0, g),
        origin + Offset(g, g),
        origin + Offset(g, 0),
        origin + Offset(u - g, 0),
        origin + Offset(u - g, g),
        origin + Offset(u, g),
        origin + Offset(u, u - g),
        origin + Offset(u - g, u - g),
        origin + Offset(u - g, u),
        origin + Offset(g, u),
        origin + Offset(g, u - g),
        origin + Offset(0, u - g),
        origin + Offset(0, u),
      ];
      for (var i = 0; i < pts.length - 1; i++) {
        canvas.drawLine(pts[i], pts[i + 1], paint);
      }
    }
  }

  void _paintBaguaTrigramTicks(Canvas canvas, Rect frameRect) {
    final center = frameRect.center;
    final tickRadius = math.min(frameRect.width, frameRect.height) / 2 - frameBand * 0.6;
    final tickPaint = Paint()
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..color = FieldWorkChinesePalette.ricePaper.withValues(alpha: hovered ? 0.75 : 0.52);

    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4 - math.pi / 2;
      final pos = center + Offset(math.cos(angle) * tickRadius, math.sin(angle) * tickRadius);
      _drawMiniTrigram(canvas, pos, angle + math.pi / 2, _frameTrigrams[i], tickPaint);
    }
  }

  void _drawMiniTrigram(
    Canvas canvas,
    Offset center,
    double rotation,
    List<bool> lines,
    Paint paint,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    final lineW = 7.0;
    final gap = 2.2;
    for (var i = 0; i < 3; i++) {
      final y = (i - 1) * gap;
      if (lines[i]) {
        canvas.drawLine(Offset(-lineW / 2, y), Offset(lineW / 2, y), paint);
      } else {
        canvas.drawLine(Offset(-lineW / 2, y), Offset(-1.2, y), paint);
        canvas.drawLine(Offset(1.2, y), Offset(lineW / 2, y), paint);
      }
    }
    canvas.restore();
  }

  void _paintDoubleCornerBrackets(Canvas canvas, Rect rect) {
    final arm = math.min(rect.width, rect.height) * 0.1;
    final inset = encroach + frameBand * 0.28;
    final outerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.square
      ..color = AppColors.accent.withValues(alpha: hovered ? 0.92 : 0.68);
    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.square
      ..color = FieldWorkChinesePalette.ricePaper.withValues(alpha: hovered ? 0.7 : 0.48);

    for (final corner in [
      Offset(rect.left + inset, rect.top + inset),
      Offset(rect.right - inset, rect.top + inset),
      Offset(rect.left + inset, rect.bottom - inset),
      Offset(rect.right - inset, rect.bottom - inset),
    ]) {
      final sx = corner.dx > rect.center.dx ? -1.0 : 1.0;
      final sy = corner.dy > rect.center.dy ? -1.0 : 1.0;
      _drawBracket(canvas, corner, sx, sy, arm, outerPaint);
      _drawBracket(
        canvas,
        corner + Offset(sx * 5, sy * 5),
        sx,
        sy,
        arm * 0.62,
        innerPaint,
      );
    }
  }

  void _drawBracket(
    Canvas canvas,
    Offset corner,
    double sx,
    double sy,
    double arm,
    Paint paint,
  ) {
    final path = Path()
      ..moveTo(corner.dx, corner.dy + sy * arm)
      ..lineTo(corner.dx, corner.dy)
      ..lineTo(corner.dx + sx * arm, corner.dy);
    canvas.drawPath(path, paint);
  }

  void _paintQiPulse(Canvas canvas, Path clipPath, Rect frameRect, double band) {
    final pulsePos = (qiPulse * 1.2) % 1.0;
    final perimeter = 2 * (frameRect.width + frameRect.height);
    final dist = pulsePos * perimeter;
    final point = _pointOnRoundedRect(frameRect, cornerRadius - encroach * 0.35, dist);

    canvas.save();
    canvas.clipPath(clipPath);
    canvas.drawCircle(
      point,
      band * 1.4,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.accentLight.withValues(alpha: hovered ? 0.45 : 0.22),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(center: point, radius: band * 1.4)),
    );
    canvas.restore();
  }

  Offset _pointOnRoundedRect(Rect rect, double radius, double distance) {
    final straightW = rect.width - 2 * radius;
    final straightH = rect.height - 2 * radius;
    final arcLen = radius * math.pi / 2;
    final segments = [
      straightW,
      arcLen,
      straightH,
      arcLen,
      straightW,
      arcLen,
      straightH,
      arcLen,
    ];
    var d = distance % (2 * (straightW + straightH) + 4 * arcLen);
    var x = rect.left + radius;
    var y = rect.top;

    for (var s = 0; s < segments.length; s++) {
      if (d <= segments[s]) {
        switch (s) {
          case 0:
            return Offset(x + d, y);
          case 1:
            final a = -math.pi / 2 + d / arcLen * math.pi / 2;
            return Offset(rect.right - radius + math.cos(a) * radius, rect.top + radius + math.sin(a) * radius);
          case 2:
            return Offset(rect.right, y + radius + d);
          case 3:
            final a = d / arcLen * math.pi / 2;
            return Offset(rect.right - radius + math.cos(a) * radius, rect.bottom - radius + math.sin(a) * radius);
          case 4:
            return Offset(rect.right - radius - d, rect.bottom);
          case 5:
            final a = math.pi / 2 + d / arcLen * math.pi / 2;
            return Offset(rect.left + radius + math.cos(a) * radius, rect.bottom - radius + math.sin(a) * radius);
          case 6:
            return Offset(rect.left, rect.bottom - radius - d);
          default:
            final a = math.pi + d / arcLen * math.pi / 2;
            return Offset(rect.left + radius + math.cos(a) * radius, rect.top + radius + math.sin(a) * radius);
        }
      }
      d -= segments[s];
    }
    return rect.topLeft;
  }

  @override
  bool shouldRepaint(covariant _MetaphysicsEncroachingFramePainter oldDelegate) {
    return oldDelegate.hovered != hovered ||
        oldDelegate.qiPulse != qiPulse ||
        oldDelegate.encroach != encroach ||
        oldDelegate.frameBand != frameBand ||
        oldDelegate.cornerRadius != cornerRadius;
  }
}
