import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import '../../home/widgets/field_work_chinese_design.dart';

/// Chapter seal emblem for Apps page section headers.
class AppsChapterSeal extends StatelessWidget {
  const AppsChapterSeal({super.key, required this.character, required this.isMobile});

  final String character;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final size = isMobile ? 36.0 : 44.0;
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

/// Thin wrapper over [FieldWorkChineseSectionHeader] for Apps chapters.
class AppsChapterHeader extends StatelessWidget {
  const AppsChapterHeader({
    super.key,
    required this.title,
    this.headline,
    this.subline,
    required this.isMobile,
    this.sealCharacter,
  });

  final String title;
  final String? headline;
  final String? subline;
  final bool isMobile;
  final String? sealCharacter;

  @override
  Widget build(BuildContext context) {
    return FieldWorkChineseSectionHeader(
      title: title,
      headline: headline,
      subline: subline,
      isMobile: isMobile,
      centerEmblem: sealCharacter != null
          ? AppsChapterSeal(character: sealCharacter!, isMobile: isMobile)
          : null,
    );
  }
}
