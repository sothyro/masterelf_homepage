import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import '../../home/widgets/field_work_chinese_design.dart';

/// Hero / product lockup: **YUK9 Pro** (3D) with subtitle or marketing tagline.
class MasterElfYuk9ProBrandTitle extends StatelessWidget {
  const MasterElfYuk9ProBrandTitle({
    super.key,
    this.systemName,
    required this.isNarrow,
    this.compact = false,
    this.subtitle,
    this.tagline,
    this.artText = 'YUK9 Pro',
  }) : assert(
          subtitle != null || tagline != null || systemName != null,
          'Provide subtitle, tagline, or systemName.',
        );

  final String? systemName;
  final String? subtitle;
  final String? tagline;
  final String artText;
  final bool isNarrow;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Yuk9Pro3DArtTitle(text: artText, isNarrow: isNarrow, compact: compact),
        if (tagline != null) ...[
          SizedBox(height: compact ? 10 : (isNarrow ? 12 : 14)),
          Text(
            tagline!,
            textAlign: TextAlign.center,
            style: _taglineStyle(isNarrow: isNarrow, compact: compact),
          ),
        ] else ...[
          SizedBox(height: compact ? 5 : (isNarrow ? 8 : 10)),
          Text(
            subtitle ?? systemName!,
            textAlign: TextAlign.center,
            style: _systemStyle(isNarrow: isNarrow, compact: compact),
          ),
        ],
      ],
    );
  }

  TextStyle _systemStyle({required bool isNarrow, required bool compact}) {
    return GoogleFonts.exo2(
      fontSize: compact ? (isNarrow ? 13.0 : 15.0) : (isNarrow ? 14.0 : 16.0),
      fontWeight: FontWeight.w500,
      letterSpacing: compact ? 0.8 : 1.0,
      height: 1.25,
      color: FieldWorkChinesePalette.ricePaper.withValues(alpha: 0.88),
    );
  }

  TextStyle _taglineStyle({required bool isNarrow, required bool compact}) {
    return GoogleFonts.exo2(
      fontSize: compact ? (isNarrow ? 16.0 : 18.0) : (isNarrow ? 18.0 : 22.0),
      fontWeight: FontWeight.w700,
      letterSpacing: compact ? (isNarrow ? 0.4 : 0.6) : (isNarrow ? 0.5 : 0.8),
      height: 1.35,
      color: FieldWorkChinesePalette.ricePaper.withValues(alpha: 0.96),
      shadows: [
        Shadow(
          color: AppColors.accentGlow.withValues(alpha: 0.35),
          blurRadius: 12,
        ),
      ],
    );
  }
}

class _Yuk9Pro3DArtTitle extends StatelessWidget {
  const _Yuk9Pro3DArtTitle({
    required this.text,
    required this.isNarrow,
    required this.compact,
  });

  final String text;
  final bool isNarrow;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final fontSize = compact
        ? (isNarrow ? 22.0 : 26.0)
        : (isNarrow ? 28.0 : 36.0);
    final letterSpacing = compact
        ? (isNarrow ? 3.0 : 4.0)
        : (isNarrow ? 4.0 : 5.5);

    final baseStyle = GoogleFonts.exo2(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      letterSpacing: letterSpacing,
      height: 1.05,
    );

    const depthLayers = [
      (dx: 0.0, dy: 5.0, color: Color(0xFF120A04), blur: 0.0),
      (dx: 0.0, dy: 3.5, color: Color(0xFF3A2208), blur: 0.0),
      (dx: 0.0, dy: 2.0, color: Color(0xFF6B3A12), blur: 0.0),
    ];

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        for (final layer in depthLayers)
          Transform.translate(
            offset: Offset(layer.dx, layer.dy),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: baseStyle.copyWith(
                color: layer.color.withValues(alpha: 0.92),
              ),
            ),
          ),
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFFF8E7),
                AppColors.accentLight,
                AppColors.accent,
                const Color(0xFFB8722A),
              ],
              stops: const [0.0, 0.35, 0.72, 1.0],
            ).createShader(bounds);
          },
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: baseStyle.copyWith(
              color: Colors.white,
              shadows: [
                Shadow(
                  color: AppColors.accentGlow.withValues(alpha: 0.55),
                  blurRadius: 14,
                ),
                Shadow(
                  color: Colors.white.withValues(alpha: 0.35),
                  offset: const Offset(0, -1),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
