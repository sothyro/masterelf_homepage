import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../theme/app_theme.dart';

/// Palette for modern Chinese-inspired field work visuals (dark + gold).
abstract final class FieldWorkChinesePalette {
  /// Brand gold accent (replaces legacy cinnabar red).
  static const Color cinnabar = AppColors.accent;
  /// Deep warm shadow tone for ink-wash backgrounds.
  static const Color cinnabarDeep = Color(0xFF1A1608);
  static const Color ink = Color(0xFF0A0908);
  static const Color inkWash = Color(0xFF14100E);
  static const Color ricePaper = Color(0xFFF3EBD9);
  static const Color jadeMuted = Color(0xFF4A6B5A);
}

/// Subtle window-lattice pattern (冰裂纹 / 回纹 inspired grid).
class ChineseLatticePainter extends CustomPainter {
  ChineseLatticePainter({
    this.color = AppColors.accent,
    this.opacity = 0.07,
    this.cellSize = 56,
  });

  final Color color;
  final double opacity;
  final double cellSize;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    final inset = cellSize * 0.18;
    for (var y = -cellSize; y < size.height + cellSize; y += cellSize) {
      for (var x = -cellSize; x < size.width + cellSize; x += cellSize) {
        final outer = Rect.fromLTWH(x + inset, y + inset, cellSize - inset * 2, cellSize - inset * 2);
        canvas.drawRect(outer, stroke);
        final inner = outer.deflate(cellSize * 0.18);
        canvas.drawRect(inner, stroke);
        canvas.drawLine(
          Offset(outer.left, outer.center.dy),
          Offset(outer.right, outer.center.dy),
          stroke,
        );
        canvas.drawLine(
          Offset(outer.center.dx, outer.top),
          Offset(outer.center.dx, outer.bottom),
          stroke,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ChineseLatticePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.opacity != opacity ||
        oldDelegate.cellSize != cellSize;
  }
}

/// Soft ink-wash radial glow for section depth.
class ChineseInkWashGlow extends StatelessWidget {
  const ChineseInkWashGlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                FieldWorkChinesePalette.cinnabarDeep.withValues(alpha: 0.55),
                FieldWorkChinesePalette.ink,
                const Color(0xFF0C0A08),
                FieldWorkChinesePalette.inkWash,
              ],
              stops: const [0.0, 0.35, 0.7, 1.0],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.55),
              radius: 1.1,
              colors: [
                AppColors.accent.withValues(alpha: 0.12),
                Colors.transparent,
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.85, 0.9),
              radius: 0.75,
              colors: [
                AppColors.accent.withValues(alpha: 0.1),
                Colors.transparent,
              ],
            ),
          ),
        ),
        CustomPaint(
          painter: ChineseLatticePainter(
            opacity: 0.055,
            cellSize: 64,
          ),
        ),
      ],
    );
  }
}

/// L-shaped gold corner brackets (traditional frame motif).
class ChineseCornerBrackets extends StatelessWidget {
  const ChineseCornerBrackets({
    super.key,
    required this.child,
    this.color = AppColors.accent,
    this.length = 22,
    this.inset = 10,
    this.strokeWidth = 1.5,
  });

  final Widget child;
  final Color color;
  final double length;
  final double inset;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        for (final alignment in const [
          Alignment.topLeft,
          Alignment.topRight,
          Alignment.bottomLeft,
          Alignment.bottomRight,
        ])
          Positioned.fill(
            child: Align(
              alignment: alignment,
              child: Padding(
                padding: EdgeInsets.all(inset),
                child: _CornerBracket(
                  alignment: alignment,
                  color: color,
                  length: length,
                  strokeWidth: strokeWidth,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CornerBracket extends StatelessWidget {
  const _CornerBracket({
    required this.alignment,
    required this.color,
    required this.length,
    required this.strokeWidth,
  });

  final Alignment alignment;
  final Color color;
  final double length;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(length, length),
      painter: _CornerBracketPainter(
        flipX: alignment.x > 0,
        flipY: alignment.y > 0,
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _CornerBracketPainter extends CustomPainter {
  _CornerBracketPainter({
    required this.flipX,
    required this.flipY,
    required this.color,
    required this.strokeWidth,
  });

  final bool flipX;
  final bool flipY;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final path = Path();
    final w = size.width;
    final h = size.height;
    final arm = w * 0.55;

    if (!flipX && !flipY) {
      path.moveTo(0, arm);
      path.lineTo(0, 0);
      path.lineTo(arm, 0);
    } else if (flipX && !flipY) {
      path.moveTo(w - arm, 0);
      path.lineTo(w, 0);
      path.lineTo(w, arm);
    } else if (!flipX && flipY) {
      path.moveTo(0, h - arm);
      path.lineTo(0, h);
      path.lineTo(arm, h);
    } else {
      path.moveTo(w - arm, h);
      path.lineTo(w, h);
      path.lineTo(w, h - arm);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CornerBracketPainter oldDelegate) => false;
}

/// Ornamental title band with central seal motif.
class FieldWorkChineseSectionHeader extends StatelessWidget {
  const FieldWorkChineseSectionHeader({
    super.key,
    required this.title,
    this.headline,
    this.subline,
    required this.isMobile,
    this.centerEmblem,
  });

  final String title;
  final String? headline;
  final String? subline;
  final bool isMobile;
  /// Custom centerpiece above the title; defaults to the square 实 seal stamp.
  final Widget? centerEmblem;

  @override
  Widget build(BuildContext context) {
    final titleStyle = highlightStyleForLocale(
      context,
      fontSize: isMobile ? 30 : 40,
      fontWeight: FontWeight.bold,
      color: AppColors.accent,
      height: 1.15,
    ).copyWith(
      shadows: [
        Shadow(
          color: AppColors.accent.withValues(alpha: 0.35),
          blurRadius: 16,
          offset: const Offset(0, 2),
        ),
      ],
    );

    final headlineStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: FieldWorkChinesePalette.ricePaper.withValues(alpha: 0.95),
          fontWeight: FontWeight.w600,
          height: 1.35,
          letterSpacing: isMobile ? 0.2 : 0.6,
        );

    final sublineStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.92),
          height: 1.5,
        );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _OrnamentalRule(isMobile: isMobile)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20),
              child: centerEmblem ?? _SealMark(size: isMobile ? 36 : 44),
            ),
            Expanded(child: _OrnamentalRule(isMobile: isMobile, mirror: true)),
          ],
        ),
        SizedBox(height: isMobile ? 16 : 20),
        Text(title, textAlign: TextAlign.center, style: titleStyle),
        if (headline != null || subline != null) ...[
          SizedBox(height: isMobile ? 14 : 18),
          ChineseJewelLine(width: isMobile ? 120 : 180),
          SizedBox(height: isMobile ? 16 : 20),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 720),
            child: Column(
              children: [
                if (headline != null) ...[
                  Text(headline!, textAlign: TextAlign.center, style: headlineStyle),
                  if (subline != null) const SizedBox(height: 10),
                ],
                if (subline != null)
                  Text(subline!, textAlign: TextAlign.center, style: sublineStyle),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _OrnamentalRule extends StatelessWidget {
  const _OrnamentalRule({required this.isMobile, this.mirror = false});

  final bool isMobile;
  final bool mirror;

  @override
  Widget build(BuildContext context) {
    final line = Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: mirror ? Alignment.centerRight : Alignment.centerLeft,
          end: mirror ? Alignment.centerLeft : Alignment.centerRight,
          colors: [
            AppColors.accent.withValues(alpha: 0.85),
            AppColors.accent.withValues(alpha: 0.15),
            Colors.transparent,
          ],
        ),
      ),
    );

    final dot = Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.accent,
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGlow.withValues(alpha: 0.35),
            blurRadius: 6,
          ),
        ],
      ),
    );

    return SizedBox(
      height: 12,
      child: Row(
        children: mirror
            ? [Expanded(child: line), const SizedBox(width: 8), dot]
            : [dot, const SizedBox(width: 8), Expanded(child: line)],
      ),
    );
  }
}

/// Diamond-centred gold rule used under section titles.
class ChineseJewelLine extends StatelessWidget {
  const ChineseJewelLine({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 10,
      child: CustomPaint(
        painter: _JewelLinePainter(),
      ),
    );
  }
}

class _JewelLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final gold = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.75)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, size.height / 2), Offset(cx - 10, size.height / 2), gold);
    canvas.drawLine(Offset(cx + 10, size.height / 2), Offset(size.width, size.height / 2), gold);

    final diamond = Path()
      ..moveTo(cx, 2)
      ..lineTo(cx + 7, size.height / 2)
      ..lineTo(cx, size.height - 2)
      ..lineTo(cx - 7, size.height / 2)
      ..close();
    canvas.drawPath(
      diamond,
      Paint()
        ..color = AppColors.accent.withValues(alpha: 0.85)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(diamond, gold);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Circular play emblem for the video spotlight band (distinct from the hero seal).
class FieldWorkVideoEmblem extends StatelessWidget {
  const FieldWorkVideoEmblem({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.accentLight,
            AppColors.accent,
            AppColors.accent.withValues(alpha: 0.82),
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
        border: Border.all(
          color: AppColors.accentLight.withValues(alpha: 0.75),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGlow.withValues(alpha: 0.45),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        LucideIcons.play,
        size: size * 0.36,
        color: AppColors.onAccent,
      ),
    );
  }
}

/// Square seal for The Method page hero — 道 (the Way).
class MethodWaySeal extends StatelessWidget {
  const MethodWaySeal({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return _ChineseCharacterSeal(size: size, character: '道');
  }
}

/// Square seal for Events page hero — 会 (gathering / assembly).
class EventsGatheringSeal extends StatelessWidget {
  const EventsGatheringSeal({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return _ChineseCharacterSeal(size: size, character: '会');
  }
}

/// Square seal for upcoming events section — 期 (upcoming period).
class EventsUpcomingSeal extends StatelessWidget {
  const EventsUpcomingSeal({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return _ChineseCharacterSeal(size: size, character: '期');
  }
}

/// Square seal for completed events section — 典 (classic / archive).
class EventsArchiveSeal extends StatelessWidget {
  const EventsArchiveSeal({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return _ChineseCharacterSeal(size: size, character: '典');
  }
}

/// Square seal for Academy page hero — 学 (learning / academy).
class AcademyLearningSeal extends StatelessWidget {
  const AcademyLearningSeal({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return _ChineseCharacterSeal(size: size, character: '学');
  }
}

/// Square seal stamp (印章) accent — shows 实 for authenticity / field work.
class _SealMark extends StatelessWidget {
  const _SealMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return _ChineseCharacterSeal(size: size, character: '实');
  }
}

/// Public seal for testimonials header — 言 (voice / words).
class TestimonialVoiceSeal extends StatelessWidget {
  const TestimonialVoiceSeal({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return _ChineseCharacterSeal(size: size, character: '言');
  }
}

class _ChineseCharacterSeal extends StatelessWidget {
  const _ChineseCharacterSeal({required this.size, required this.character});

  final double size;
  final String character;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.accentLight.withValues(alpha: 0.65), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGlow.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        character,
        style: GoogleFonts.notoSerifSc(
          fontSize: size * 0.52,
          fontWeight: FontWeight.w700,
          color: AppColors.onAccent,
          height: 1,
        ),
      ),
    );
  }
}

/// Scroll-style mounting bar under card images.
class ChineseMountingBar extends StatelessWidget {
  const ChineseMountingBar({super.key, this.accentColor = AppColors.accent});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.accent.withValues(alpha: 0.65),
            accentColor,
            AppColors.accent.withValues(alpha: 0.65),
            Colors.transparent,
          ],
          stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
        ),
      ),
    );
  }
}

/// Circular realm seal on showcase cards.
class ChineseRealmSeal extends StatelessWidget {
  const ChineseRealmSeal({
    super.key,
    required this.icon,
    required this.accentColor,
    this.indexLabel,
  });

  final IconData icon;
  final Color accentColor;
  final String? indexLabel;

  static const _labels = ['壹', '贰', '叁', '肆'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: FieldWorkChinesePalette.ink.withValues(alpha: 0.72),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.85),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.25),
            blurRadius: 10,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, size: 22, color: accentColor),
          if (indexLabel != null)
            Positioned(
              right: 2,
              bottom: 0,
              child: Text(
                indexLabel!,
                style: GoogleFonts.notoSerifSc(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                  height: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }

  static String? labelForIndex(int index) {
    if (index < 0 || index >= _labels.length) return null;
    return _labels[index];
  }
}

/// CTA panel with Chinese frame for section footers.
class FieldWorkChineseCtaPanel extends StatelessWidget {
  const FieldWorkChineseCtaPanel({
    super.key,
    required this.child,
    required this.isMobile,
  });

  final Widget child;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return ChineseCornerBrackets(
      length: isMobile ? 14 : 18,
      inset: isMobile ? 10 : 14,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 28,
          vertical: isMobile ? 20 : 24,
        ),
        decoration: BoxDecoration(
          color: FieldWorkChinesePalette.inkWash.withValues(alpha: 0.65),
          border: Border.all(
            color: AppColors.borderDark,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: child,
      ),
    );
  }
}

/// Double gold rim + ink bezel + corner brackets for dialogs / featured panels.
///
/// Scales rim thickness, radius, and bracket size for mobile vs desktop so the
/// frame stays proportional inside tight [Dialog] inset padding.
class ChineseDialogFrame extends StatelessWidget {
  const ChineseDialogFrame({
    super.key,
    required this.child,
    required this.isMobile,
  });

  final Widget child;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final outerRadius = isMobile ? 16.0 : 20.0;
    final innerRadius = isMobile ? 11.0 : 14.0;
    final bezel = isMobile ? 3.5 : 5.5;
    final outerStroke = isMobile ? 1.15 : 1.45;
    final bracketLength = isMobile ? 18.0 : 26.0;
    final bracketInset = isMobile ? 5.0 : 8.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(outerRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.48),
            blurRadius: isMobile ? 18 : 28,
            offset: Offset(0, isMobile ? 8 : 12),
          ),
          BoxShadow(
            color: AppColors.accentGlow.withValues(alpha: isMobile ? 0.16 : 0.22),
            blurRadius: isMobile ? 20 : 34,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(outerRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accentLight.withValues(alpha: 0.72),
              AppColors.accent.withValues(alpha: 0.9),
              AppColors.accent.withValues(alpha: 0.55),
              AppColors.accentLight.withValues(alpha: 0.65),
            ],
            stops: const [0.0, 0.32, 0.68, 1.0],
          ),
        ),
        padding: EdgeInsets.all(outerStroke),
        child: Container(
          padding: EdgeInsets.all(bezel),
          decoration: BoxDecoration(
            color: FieldWorkChinesePalette.ink,
            borderRadius: BorderRadius.circular(
              (outerRadius - outerStroke).clamp(0, outerRadius),
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(innerRadius),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.38),
                width: isMobile ? 0.9 : 1.1,
              ),
            ),
            child: ChineseCornerBrackets(
              length: bracketLength,
              inset: bracketInset,
              strokeWidth: isMobile ? 1.15 : 1.35,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  (innerRadius - 1).clamp(0, innerRadius),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Pill index tag along the top edge of a card (modern 序号 strip).
class ChinesePillarIndexTag extends StatelessWidget {
  const ChinesePillarIndexTag({
    super.key,
    required this.index,
    required this.accentColor,
  });

  final int index;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final label = (index + 1).toString().padLeft(2, '0');
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: FieldWorkChinesePalette.ink.withValues(alpha: 0.8),
          border: Border(
            bottom: BorderSide(color: accentColor.withValues(alpha: 0.7)),
            right: BorderSide(color: accentColor.withValues(alpha: 0.35)),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.exo2(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: accentColor,
          ),
        ),
      ),
    );
  }
}
