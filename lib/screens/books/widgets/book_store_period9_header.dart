import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/breakpoints.dart';
import '../../store/widgets/description_with_highlight.dart';

/// Ornate centered header for the Period 9 book series section.
class BookStorePeriod9SeriesHeader extends StatelessWidget {
  const BookStorePeriod9SeriesHeader({super.key, required this.l10n});

  final AppLocalizations l10n;

  static const Key headerKey = ValueKey<String>('book-store-period9-series-header');

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = Breakpoints.isMobile(width);

    final titleStyle = highlightStyleForLocale(
      context,
      fontSize: isMobile ? 28 : 36,
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

    final kickerStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.onSurfaceVariantDark.withValues(alpha: 0.92),
          fontWeight: FontWeight.w600,
          letterSpacing: isMobile ? 0.3 : 0.6,
          height: 1.35,
        );

    return Column(
      key: headerKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _OrnamentalRule(isMobile: isMobile)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20),
              child: _Period9Seal(size: isMobile ? 40 : 48),
            ),
            Expanded(child: _OrnamentalRule(isMobile: isMobile, mirror: true)),
          ],
        ),
        SizedBox(height: isMobile ? 16 : 20),
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 14 : 18,
              vertical: isMobile ? 6 : 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.accent.withValues(alpha: 0.55)),
              color: AppColors.accent.withValues(alpha: 0.08),
            ),
            child: Text(
              l10n.bookStorePeriod9EraBadge,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.accent.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
            ),
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        Text(
          l10n.bookStorePeriod9SeriesKicker,
          textAlign: TextAlign.center,
          style: kickerStyle,
        ),
        SizedBox(height: isMobile ? 14 : 18),
        Text(
          l10n.bookStorePeriod9SeriesHeading,
          textAlign: TextAlign.center,
          style: titleStyle,
        ),
        SizedBox(height: isMobile ? 16 : 20),
        Center(child: _CenterJewelLine(width: isMobile ? 120 : 180)),
        SizedBox(height: isMobile ? 16 : 20),
        DescriptionWithHighlight(
          description: l10n.bookStorePeriod9SeriesIntro,
          highlightPhrase: l10n.bookStorePeriod9SeriesIntroHighlight,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _Period9Seal extends StatelessWidget {
  const _Period9Seal({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.85), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGlow.withValues(alpha: 0.3),
            blurRadius: 12,
          ),
        ],
        gradient: RadialGradient(
          colors: [
            AppColors.accent.withValues(alpha: 0.15),
            const Color(0xFF1A1608),
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        '九',
        style: GoogleFonts.notoSerifSc(
          fontSize: size * 0.52,
          fontWeight: FontWeight.w700,
          color: AppColors.accent,
          height: 1,
        ),
      ),
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

class _CenterJewelLine extends StatelessWidget {
  const _CenterJewelLine({required this.width});

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
