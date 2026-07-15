import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../screens/home/widgets/field_work_chinese_design.dart';
import '../theme/app_theme.dart';
import '../utils/breakpoints.dart';
import 'majestic_orbital_card_frame.dart';
import 'social_popup_yuk9_orbits.dart';

/// Side-by-side Facebook and Telegram on a YUK9 Pro metaphysics orbit stage.
class SocialOrbitalPair extends StatefulWidget {
  const SocialOrbitalPair({
    super.key,
    required this.onFacebook,
    required this.onTelegram,
    required this.facebookLabel,
    required this.telegramLabel,
  });

  final VoidCallback onFacebook;
  final VoidCallback onTelegram;
  final String facebookLabel;
  final String telegramLabel;

  static const _facebookGlow = Color(0xFF1877F2);
  static const _telegramGlow = Color(0xFF2AABEE);

  /// Room for Bagua / Lo Shu rings around the icon core.
  static const _orbitPad = 52.0;

  /// Soft halo extending past the orbit stage.
  static const _spotlightBleed = 48.0;

  static const _orbitExtentScale = 1.27;

  static double iconSizeForAvailableWidth(double availableWidth) {
    final gap = availableWidth < Breakpoints.mobile ? 24.0 : 48.0;
    const framePadH = 36.0;
    const overhead = framePadH * 2 + _orbitPad * 2 + _spotlightBleed * 2;
    final raw = (availableWidth - gap - overhead) / 2;
    if (availableWidth < Breakpoints.mobile) {
      return raw.clamp(56.0, 88.0);
    }
    if (availableWidth < Breakpoints.tablet) {
      return raw.clamp(80.0, 108.0);
    }
    return raw.clamp(96.0, 120.0);
  }

  @override
  State<SocialOrbitalPair> createState() => _SocialOrbitalPairState();
}

class _SocialOrbitalPairState extends State<SocialOrbitalPair>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cycle;
  bool _animationEnabled = true;
  bool _hoverFacebook = false;
  bool _hoverTelegram = false;

  static const _idleWobbleStrength = 0.62;
  static const _hoverWobbleStrength = 1.0;
  static const _idleWobbleSpeed = 0.82;

  bool get _hovered => _hoverFacebook || _hoverTelegram;

  @override
  void initState() {
    super.initState();
    _cycle = AnimationController(
      vsync: this,
      duration: kMajesticOrbitalCycleDuration,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _animationEnabled) _cycle.repeat();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disable = MediaQuery.disableAnimationsOf(context);
    if (disable && _animationEnabled) {
      _animationEnabled = false;
      _cycle.stop();
    } else if (!disable && !_animationEnabled) {
      _animationEnabled = true;
      if (!_cycle.isAnimating) _cycle.repeat();
    }
  }

  @override
  void dispose() {
    _cycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width - 48;
        final iconSize = SocialOrbitalPair.iconSizeForAvailableWidth(available);
        final gap = available < Breakpoints.mobile ? 24.0 : 48.0;
        const framePadV = 44.0;
        const framePadH = 36.0;
        final coreW = iconSize * 2 + gap + framePadH * 2;
        final coreH = iconSize + framePadV * 2;
        final orbitStageW = coreW + SocialOrbitalPair._orbitPad * 2;
        final orbitStageH = coreH + SocialOrbitalPair._orbitPad * 2;
        final totalW = orbitStageW + SocialOrbitalPair._spotlightBleed * 2;
        final totalH = orbitStageH + SocialOrbitalPair._spotlightBleed * 2;

        return RepaintBoundary(
          child: SizedBox(
            width: totalW,
            height: totalH,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                if (_animationEnabled)
                  _AnimatedSpotlightHalo(
                    animation: _cycle,
                    width: orbitStageW + SocialOrbitalPair._spotlightBleed * 1.4,
                    height: orbitStageH + SocialOrbitalPair._spotlightBleed * 1.4,
                  ),
                SizedBox(
                  width: orbitStageW,
                  height: orbitStageH,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      if (_animationEnabled)
                        Positioned.fill(
                          child: RepaintBoundary(
                            child: AnimatedBuilder(
                              animation: _cycle,
                              builder: (context, _) {
                                return IgnorePointer(
                                  child: SocialPopupYuk9Orbits(
                                    progress: _cycle.value,
                                    hovered: _hovered,
                                    extentScale: SocialOrbitalPair._orbitExtentScale,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      _AnimatedIconCore(
                        animation: _cycle,
                        animationEnabled: _animationEnabled,
                        hovered: _hovered,
                        child: RepaintBoundary(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _SocialChannelTile(
                                key: const Key('social-orbital-facebook'),
                                icon: LucideIcons.facebook,
                                glowColor: SocialOrbitalPair._facebookGlow,
                                size: iconSize,
                                semanticLabel: widget.facebookLabel,
                                hovered: _hoverFacebook,
                                onHover: (v) => setState(() => _hoverFacebook = v),
                                onTap: widget.onFacebook,
                              ),
                              SizedBox(width: gap),
                              _SocialChannelTile(
                                key: const Key('social-orbital-telegram'),
                                icon: LucideIcons.send,
                                glowColor: SocialOrbitalPair._telegramGlow,
                                size: iconSize,
                                semanticLabel: widget.telegramLabel,
                                hovered: _hoverTelegram,
                                onHover: (v) => setState(() => _hoverTelegram = v),
                                onTap: widget.onTelegram,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Spotlight halo — isolated repaint from orbit rings and icons.
class _AnimatedSpotlightHalo extends StatelessWidget {
  const _AnimatedSpotlightHalo({
    required this.animation,
    required this.width,
    required this.height,
  });

  final Animation<double> animation;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: width,
        height: height,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            final breath = 0.5 + 0.5 * math.sin(animation.value * math.pi * 2);
            return IgnorePointer(
              child: CustomPaint(
                painter: _SocialSpotlightPainter(breath: breath),
                child: const SizedBox.expand(),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Gentle float + tilt on the icon row, synced to the orbital cycle.
class _AnimatedIconCore extends StatelessWidget {
  const _AnimatedIconCore({
    required this.animation,
    required this.animationEnabled,
    required this.hovered,
    required this.child,
  });

  final Animation<double> animation;
  final bool animationEnabled;
  final bool hovered;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!animationEnabled) {
      return child;
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final t = animation.value;
        final wobbleStrength =
            hovered ? _SocialOrbitalPairState._hoverWobbleStrength : _SocialOrbitalPairState._idleWobbleStrength;
        final wobbleSpeed =
            hovered ? kMajesticHoverWobbleSpeed : _SocialOrbitalPairState._idleWobbleSpeed;
        final wobbleX = majesticOrbitalHoverTiltWobble(
              t,
              phase: 0.4,
              speed: wobbleSpeed,
            ) *
                wobbleStrength +
            (hovered ? -0.014 : -0.007);
        final wobbleY = majesticOrbitalHoverTiltWobble(
              t,
              phase: 1.85,
              speed: wobbleSpeed,
            ) *
                wobbleStrength +
            (hovered ? 0.02 : 0.01);
        final lift = majesticOrbitalHoverFloat(
              t,
              phase: 0.9,
              speed: wobbleSpeed,
            ) *
                wobbleStrength +
            (hovered ? -5.0 : -2.5);

        return Transform.translate(
          offset: Offset(0, lift),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0014)
              ..rotateX(wobbleX)
              ..rotateY(wobbleY),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _SocialChannelTile extends StatelessWidget {
  const _SocialChannelTile({
    super.key,
    required this.icon,
    required this.glowColor,
    required this.size,
    required this.semanticLabel,
    required this.hovered,
    required this.onHover,
    required this.onTap,
  });

  final IconData icon;
  final Color glowColor;
  final double size;
  final String semanticLabel;
  final bool hovered;
  final ValueChanged<bool> onHover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconSize = size * 0.4;

    return Semantics(
      button: true,
      label: semanticLabel,
      child: MouseRegion(
        onEnter: (_) => onHover(true),
        onExit: (_) => onHover(false),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedScale(
            scale: hovered ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            child: ChineseCornerBrackets(
              length: size * 0.22,
              inset: 4,
              strokeWidth: hovered ? 2 : 1.25,
              color: hovered
                  ? glowColor.withValues(alpha: 0.9)
                  : AppColors.accent.withValues(alpha: 0.65),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.surfaceElevatedDark.withValues(alpha: 0.95),
                      FieldWorkChinesePalette.inkWash.withValues(alpha: 0.92),
                    ],
                  ),
                  border: Border.all(
                    color: hovered
                        ? glowColor.withValues(alpha: 0.8)
                        : AppColors.borderLight.withValues(alpha: 0.4),
                    width: hovered ? 2 : 1.25,
                  ),
                  boxShadow: hovered
                      ? [
                          BoxShadow(
                            color: glowColor.withValues(alpha: 0.32),
                            blurRadius: 28,
                            spreadRadius: -2,
                          ),
                          BoxShadow(
                            color: AppColors.accentGlow.withValues(alpha: 0.12),
                            blurRadius: 20,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                ),
                child: Icon(
                  icon,
                  size: iconSize,
                  color: hovered ? Colors.white : AppColors.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Soft radial glow behind the orbit stage.
class _SocialSpotlightPainter extends CustomPainter {
  _SocialSpotlightPainter({required this.breath});

  final double breath;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final halo = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.78,
        colors: [
          AppColors.accentLight.withValues(alpha: 0.16 + breath * 0.07),
          AppColors.accent.withValues(alpha: 0.06 + breath * 0.03),
          Colors.transparent,
        ],
        stops: const [0.0, 0.42, 1.0],
      ).createShader(rect);
    canvas.drawOval(rect, halo);

    final core = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.07 + breath * 0.04),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: rect.center,
          radius: size.shortestSide * 0.32,
        ),
      );
    canvas.drawOval(rect.deflate(size.shortestSide * 0.12), core);
  }

  @override
  bool shouldRepaint(covariant _SocialSpotlightPainter oldDelegate) {
    return oldDelegate.breath != breath;
  }
}
